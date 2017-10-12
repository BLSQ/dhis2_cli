require_relative "../../lib/dhis2_cli"

describe OrgUnitsFile do
  let(:filepath) { "./spec/fixtures/org_units_template.csv" }
  let(:csv) { CSV.read(filepath, "r") }
  subject { OrgUnitsFile.new(filepath, csv.first, csv.drop(1)) }

  def traverse(candidate)
    result = []
    result << candidate.name
    candidate.children.each do |child|
      result << traverse(child) if candidate.children
    end
    result.flatten
  end

  describe "level_headers", :unit do
    it "does return the level headers" do
      expect(subject.level_headers).to eq %w[level_1 level_2 level_3]
    end
  end

  describe "candidate_lines", :unit do
    it "does return a list of candidate lines with their index" do
      expected_candidate_lines = [OpenStruct.new(external_path: nil,
                                                 dhis2_path:    nil,
                                                 level_1:       "Belgique",
                                                 level_2:       "Bruxelles",
                                                 level_3:       "Watermael",
                                                 facility_name: "Hive5",
                                                 line_number:   1),
                                  OpenStruct.new(external_path: nil,
                                                 dhis2_path:    nil,
                                                 level_1:       "Belgique",
                                                 level_2:       "Anvers",
                                                 level_3:       "Arendonk",
                                                 facility_name: "Havn",
                                                 line_number:   2)]
      expect(subject.candidate_lines).to eq expected_candidate_lines
    end
  end

  describe "root" do
    it "does return a valid tree", :unit do
      expected_order = %w[Belgique Bruxelles Watermael Anvers Arendonk]
      expect(traverse(subject.root)).to eq expected_order
    end

    it "does return the root element of a tree", :unit do
      expect(subject.root.name).to eq "Belgique"
    end
  end
end
