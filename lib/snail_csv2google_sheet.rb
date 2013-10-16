require 'csv'
require 'bigdecimal'
require 'bigdecimal'
require 'active_support/all'
require 'core_ext/vim'

class SnailTable
  attr_accessor :reader, :header

  def initialize(path)
    @reader = CSV.open(path, 'r')
    @reader.shift
  end

  def tasks
    @tasks ||= @reader.each_with_object([]) { |row, result|
      result << SnailRow.new(row, @header)
    }.sort
  end
end

class SnailRow
  TODAY = Time.new
  HEADERS = ['Title', 'Status', 'Start Date', 'Completion Date', 'Time Spent'].freeze

  def initialize(row, header)
    @original_row = row
  end

  # #title, #time_spent, #status, #start_date, #time_spent
  HEADERS.each do |head_name|
    define_method "#{head_name.gsub(/\s/, '').underscore}" do
      to_h[head_name]
    end
  end

  def to_h
    return @hash_row if @hash_row

    @hash_row = {}
    @original_row.each_with_index do |value, idx|
      @hash_row[HEADERS[idx]] = convert_value_to_ruby_class(value)
    end

    @hash_row
  end

  private

  def convert_value_to_ruby_class(value)
    if /(?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2})/ =~ value
      Time.new(TODAY.year, TODAY.month, TODAY.day, hour, minute, second)
    elsif /\d{4}-\d{2}-\d{2}/ =~ value
      Date.parse(value)
    else
      value
    end
  end

  def <=>(other)
    start_date <=> other.start_date
  end

  def method_missing(action, *args)
    if /is_(?<status_str>.*?)\?$/ =~ action
      return status == status_str.camelize
    end

    return to_h.send(action, *args) if to_h.respond_to?(action)
    super
  end
end

class Time
  def to_work_time
    (hour.to_f + (min / 60.0)).round(2)
  end
end
