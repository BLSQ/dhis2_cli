require_relative '../../lib/dhis2_cli'

describe DataValuesHelper do
  describe 'import' do
    let(:filepath) { './spec/fixtures/data_values_integration_template.csv' }
    let(:csv) { CSV.read(filepath, 'r') }
    let(:data_values_file) { DataValuesFile.new(filepath, csv.first, csv.drop(1)) }
    let(:uri) { 'https://admin:district@play.dhis2.org/demo' }
    subject { DataValuesHelper.new(uri) }

    it 'does import the csv file which contains data values', :int do
      subject.import data_values_file
    end
  end
end
