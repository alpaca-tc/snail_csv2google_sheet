require 'csv'

class SnailTable
  attr_accessor :tasks, :header

  def initialize(path)
    CSV.open(path, 'r') do |f|
      @header = f.shift.map { |v| v }

      @tasks = f.each_with_object([]) do |row, result|
        new_row = {}
        row.each_with_index do |body, index|
          body ||= ''
          new_row[@header[index]] = body
        end

        result << new_row
      end
    end
  end
end
