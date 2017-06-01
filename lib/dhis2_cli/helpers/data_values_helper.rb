# Used to import data values in DHIS2
class DataValuesHelper
  def initialize(uri)
    @dhis2_dest = DHIS2Helper.new uri
  end

  def import(data_values_file)
    data_values = data_values_file.data_values.delete_if { |v| v[:value].nil? }
    data_values.each do |data_value|
      @dhis2_dest.client.data_value_sets.create([data_value])
    end
  end
end
