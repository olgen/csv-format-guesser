require 'rchardet'
class CsvFormatGuesser
  attr_reader :encoding, :col_sep, :quote_char
  VERSION = '0.0.2'
  PREVIEW_LINES = 100
  PREVIEW_BYTES = 10 * 1024

  DEFAULT_ENCODING =  'UTF-8'.freeze
  DEFAULT_QUOTE_CHAR = "\x00".freeze

  def initialize(path)
    @path = path
    guess_encoding()
    guess_col_sep()
    guess_quote_char()
  end

  def csv_opts
    {
      encoding: @encoding,
      col_sep: @col_sep,
      quote_char: @quote_char,
    }
  end

  protected

  def guess_encoding
    cd = CharDet.detect(File.read(@path, PREVIEW_BYTES))
    @encoding = cd['encoding'] if cd
    @encoding ||= DEFAULT_ENCODING
    try_encoding_with_fallback!
  rescue Encoding::UndefinedConversionError => e
    @encoding = 'ISO-8859-1' if @encoding == 'ISO-8859-7'
  rescue => e
    @encoding = DEFAULT_ENCODING
  end

  def try_encoding_with_fallback!
    File.open(@path, "r", encoding: @encoding) do |f|
      f.read
    end
  end

  POTENTIAL_COL_SEP_REGEX = /[^\w ]/i
  # we assume that the separater is non alphanumeric and has the same
  # occurencies in the top lines
  def guess_col_sep
    header = find_header
    raise "Could not find header_row from file: #{@path}" unless header
    char_stats = header.scan(POTENTIAL_COL_SEP_REGEX).inject(Hash.new(0)) {|h,char| h[char]+=1; h}
    # here we sort all possible col seps by their count in the header
    @most_appearing = char_stats.to_a.sort{|a,b| b[1] <=> a[1]}.first
    @col_sep = @most_appearing.first if @most_appearing
    raise "Could not guess column_separator from file: #{@path}" unless @col_sep
  rescue => e
    @col_sep ||= ','
  end

  def find_header
    preview_lines.each do |line|
      return line if line.scan(POTENTIAL_COL_SEP_REGEX).any?
    end
  end

  COMMON_QUOTE_CHARS = [ '"', '\'']
  def guess_quote_char
    readlines do |line|
      @quote_char = search_quote_char(line)
      return if @quote_char
    end
    @quote_char = DEFAULT_QUOTE_CHAR
  end

  def search_quote_char(line)
    @used_quote_chars ||= []
    COMMON_QUOTE_CHARS.each do |char|
      next unless line.include?(char)
      @used_quote_chars << char
      # should be next to field separator
      if line.include?(char)
        enclosed = @col_sep + line + @col_sep
        openings = enclosed.scan( Regexp.new(Regexp.escape(@col_sep+char)) ).length
        closings = enclosed.scan( Regexp.new(Regexp.escape(char + @col_sep)) ).length
        return char if openings > 0 && openings == closings
      end
    end
    return nil
  end

  def preview_lines
    @preview_lines ||= readlines(PREVIEW_LINES)
  end

  def readlines(max = nil, &block)
    lines = []
    File.open(@path, "r:#{@encoding}:utf-8") do |f|
      i = 0
      f.each_line do |line|
        i += 1
        break if max && i > max
        if block
          yield(line)
        else
          lines << line
        end
      end
    end
    return lines
  end

end
