# frozen_string_literal: true

require_relative '../../lib/dhis2_cli'

describe DataElementImportHelper do
  describe 'import' do
    let(:dhis2) do
      Dhis2::Client.new(
        url: "https://play.dhis2.org/demo",
        user: 'admin',
        password: 'district'
      )
    end

    let(:import_helper) { DataElementImportHelper.new(dhis2) }

    it 'should import the csv file' do
      entity_file = DataElementFile.new './spec/fixtures/data_elements.csv'
      import_helper.import entity_file
    end
  end
end
