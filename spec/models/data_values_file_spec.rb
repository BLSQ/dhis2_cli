require_relative '../../lib/dhis2_cli'

describe DataValuesFile do
  let(:filepath) { './spec/fixtures/data_values_template.csv' }
  let(:csv) { CSV.read(filepath, 'r') }
  subject { DataValuesFile.new(filepath, csv.first, csv.drop(1)) }

  describe 'data_element_headers', :unit do
    it 'does returns the data elements headers' do
      expect(subject.data_element_headers).to eq %w[de_2016_abc321 de_2014Q1_xyz321]
    end
  end

  describe 'data_values_lines', :unit do
    it 'does returns the list of data values with the values and the org unit id' do
      expected_data_values_lines = [
        OpenStruct.new(external_path: nil,
                       dhis2_path: '/pM/Jk/ls/lvPW1gVZxnz',
                       level_1: 'Belgique',
                       level_2: 'Bruxelles',
                       level_3: 'Watermael',
                       facility_name: 'Hive5',
                       de_2016_abc321: '324',
                       de_2014Q1_xyz321: '443',
                       line_number: 1),
        OpenStruct.new(external_path: nil,
                       dhis2_path: '/pL/uy/Mp/uw/CKJmfUJ4mSO',
                       level_1: 'Belgique',
                       level_2: 'Anvers',
                       level_3: 'Arendonk',
                       facility_name: 'Havn',
                       de_2016_abc321: '221',
                       de_2014Q1_xyz321: '421',
                       line_number: 2)
      ]
      expect(subject.data_values_lines).to eq expected_data_values_lines
    end
  end

  describe 'import' do
    it 'does returns the list of data values to be imported', :unit do
      expected_data_values = [
        { period: '2016', dataElement: 'abc321', value: '324', orgUnit: 'lvPW1gVZxnz' },
        { period: '2014Q1', dataElement: 'xyz321', value: '443', orgUnit: 'lvPW1gVZxnz' },
        { period: '2016', dataElement: 'abc321', value: '221', orgUnit: 'CKJmfUJ4mSO' },
        { period: '2014Q1', dataElement: 'xyz321', value: '421', orgUnit: 'CKJmfUJ4mSO' }
      ]

      expect(subject.data_values).to eq expected_data_values
    end
  end
end
