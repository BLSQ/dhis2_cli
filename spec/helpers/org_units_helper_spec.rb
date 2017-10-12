require_relative "../../lib/dhis2_cli"

describe OrgUnitsHelper do
  let(:filepath) { "./spec/fixtures/int_org_units_insert.csv" }
  let(:csv) { CSV.read(filepath, "r") }
  let(:new_org_units_file) { OrgUnitsFile.new(filepath, csv.first, csv.drop(1)) }
  let(:uri) { "https://admin:district@dhis2-demo.herokuapp.com" }
  subject { OrgUnitsHelper.new(uri) }

  describe "import" do
    it "should insert new org unit into dhis2 from csv file and output an export file", :int do
      subject.import new_org_units_file
    end
  end
end
