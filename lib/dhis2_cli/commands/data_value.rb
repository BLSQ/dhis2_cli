# OrgUnit command
class DataValue < Thor
  desc "import", "import"
  desc "import", "importing data values from csv file"
  option :file, required: true
  option :dest, required: true
  def import
    lines = CSV.read(options[:file], "r")
    headers = lines.shift
    data_values_file = DataValuesFile.new(options[:dest], headers, lines)
    data_values_helper = DataValuesHelper.new options[:dest]
    data_values_helper.import data_values_file
  end
end
