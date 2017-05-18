require_relative '../../lib/dhis2_cli'

describe ImportHelper do
  describe 'import' do
    it 'should import the csv file' do
     entity_file = EntityFile.new './spec/fixtures/tamara_test.csv'
     puts entity_file.levels
      expect(entity_file.levels).to eq %w(level_1 level_2 level_3 level_4)
      import_helper = ImportHelper.new
      import_helper.import (entity_file)
      #expect(import_helper.import (entity_file)).to eq ''
    end
  end
end
