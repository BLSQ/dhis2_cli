# Represent a data value file
class DataValuesFile
  attr_reader :filepath, :headers, :lines

  def initialize(filepath, headers, lines)
    @filepath = filepath
    @headers = headers
    @lines = lines
  end

  def data_element?(header)
    header.start_with?('de')
  end

  def data_element_headers
    @data_element_headers ||= @headers.select { |header| data_element?(header) }
  end

  def data_values_lines
    @data_values_lines ||= @lines.each_with_index.map do |line, index|
      OpenStruct.new Hash[@headers.zip line].merge(line_number: index + 1)
    end
  end

  def data_values
    data_values_lines.flat_map do |data_value_line|
      data_element_headers.map do |data_element|
        data_value = Hash[[:period, :dataElement].zip data_element.split('_').drop(1)]
        data_value[:value] = data_value_line[data_element]
        data_value[:orgUnit] = data_value_line[:dhis2_path].split('/').drop(1).last
        data_value
      end
    end
  end
end
