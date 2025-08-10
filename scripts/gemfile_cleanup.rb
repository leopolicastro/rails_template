# frozen_string_literal: true

class GemfileParser
  GROUP_PATTERNS = {
    development_test: /^(?:gem_group|group)\s+:development,\s*:test\s+do/,
    development: /^(?:gem_group|group)\s+:development\s+do/,
    test: /^(?:gem_group|group)\s+:test\s+do/,
    production: /^(?:gem_group|group)\s+:production\s+do/
  }.freeze

  GROUP_HEADERS = {
    development_test: "group :development, :test do\n",
    development: "group :development do\n",
    test: "group :test do\n",
    production: "group :production do\n"
  }.freeze

  GROUP_ORDER = %i[development_test development test production].freeze

  GemEntry = Struct.new(:comments, :gem)

  def initialize(gemfile_path = "Gemfile")
    @gemfile_path = gemfile_path
    @gems_by_group = Hash.new { |h, k| h[k] = [] }
    @header_content = []
    @comment_buffer = []
    @current_group = :main
    @inside_group = false
    @group_indent = ""
  end

  def parse_and_cleanup
    return unless File.exist?(@gemfile_path)

    parse_gemfile
    write_cleaned_gemfile
  end

  private

  def parse_gemfile
    File.foreach(@gemfile_path) { |line| process_line(line) }
    flush_trailing_header_comments
  end

  def process_line(line)
    stripped = line.strip

    if group_start?(stripped)
      start_group(stripped, line)
      return
    end

    if group_end?(stripped)
      end_group
      return
    end

    if comment_or_empty?(stripped)
      buffer_comment(line)
      return
    end

    if gem_line?(stripped)
      record_gem(line)
      return
    end

    handle_non_gem_non_comment(line)
  end

  # --- classification helpers ---

  def group_start?(stripped) = GROUP_PATTERNS.values.any? { |rx| rx.match?(stripped) }

  def group_end?(stripped) = stripped == "end" && @inside_group

  def gem_line?(stripped) = stripped.start_with?("gem ")

  def comment_or_empty?(s) = s.start_with?("#") || s.empty?

  def detect_group(stripped)
    GROUP_PATTERNS.each { |name, rx| return name if rx.match?(stripped) }
    :main
  end

  # --- state transitions ---

  def start_group(stripped, line)
    @current_group = detect_group(stripped)
    @inside_group = true
    @group_indent = line[/^(\s*)/, 1] || ""
    @comment_buffer.clear
  end

  def end_group
    @inside_group = false
    @current_group = :main
    @group_indent = ""
    @comment_buffer.clear
  end

  # --- builders ---

  def buffer_comment(line)
    @comment_buffer << normalized(line)
  end

  def record_gem(line)
    @gems_by_group[@current_group] << GemEntry.new(@comment_buffer.dup, normalized(line))
    @comment_buffer.clear
  end

  def handle_non_gem_non_comment(line)
    # During the header phase (before any main gems) we keep lines in the header.
    if header_phase?
      @header_content.concat(@comment_buffer) if @comment_buffer.any?
      @header_content << line
      @comment_buffer.clear
    else
      # Outside header: carry miscellaneous lines as trailing comments if not in a group
      @comment_buffer << line unless @inside_group
    end
  end

  def header_phase?
    !@inside_group && @current_group == :main && @gems_by_group[:main].empty?
  end

  def flush_trailing_header_comments
    return unless @comment_buffer.any?
    return unless header_phase?

    @header_content.concat(@comment_buffer)
    @comment_buffer.clear
  end

  def normalized(line)
    return line unless @inside_group && @group_indent && !@group_indent.empty?
    line.sub(/^#{Regexp.escape(@group_indent)}/, "  ")
  end

  # --- writing ---

  def write_cleaned_gemfile
    require "stringio"
    buf = StringIO.new

    @header_content.each { |l| buf << l }

    # grouped gems in a consistent order
    GROUP_ORDER.each { |group| emit_group(buf, group) }

    # main gems (no group wrapper)
    @gems_by_group[:main].each { |entry| emit_gem(buf, entry) }

    File.write(@gemfile_path, buf.string)
  end

  def emit_group(buf, group)
    entries = @gems_by_group[group]
    return if entries.empty?

    buf << "\n" << GROUP_HEADERS.fetch(group)
    entries.each { |entry| emit_gem(buf, entry) }
    buf << "end\n"
  end

  def emit_gem(buf, entry)
    entry.comments.each { |c| buf << c }
    buf << entry.gem
  end
end

GemfileParser.new.parse_and_cleanup
collect_message("Gemfile cleanup completed - duplicate gem groups consolidated", :completion)
