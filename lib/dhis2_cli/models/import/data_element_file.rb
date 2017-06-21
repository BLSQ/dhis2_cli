require 'csv'
class DataElementFile
  def initialize(file_path)
    @file_path = file_path
    @headers = CSV.open(@file_path, 'r', &:first)
    lines = CSV.read(@file_path)
    lines.shift
    @data_elements = lines.each_with_index.map do |entity_line, index|
      OpenStruct.new Hash[@headers.zip entity_line].merge(line_number: index + 1)
    end
  end

  attr_reader :data_elements
end
