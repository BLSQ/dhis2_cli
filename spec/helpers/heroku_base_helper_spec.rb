require_relative "../../lib/dhis2_cli/helpers/heroku_base_helper"

describe HerokuBaseHelper do
  let(:heroku) { HerokuBaseHelper.new }

  describe "valid_app_name?" do
    it "does returns true if app name is valid", :unit do
      expect(heroku.valid_app_name?("valid-name")).to eq true
    end

    it "does returns false if app name is not valid", :unit do
      expect(heroku.valid_app_name?("invalid_name")).to eq false
    end
  end

  describe "valid_db_plan?" do
    it "does returns true if db plan is valid", :unit do
      expect(heroku.valid_db_plan?("hobby-dev")).to eq true
    end

    it "does returns false if db plan is not valid", :unit do
      expect(heroku.valid_db_plan?("invalid-db-plan")).to eq false
    end

    describe "#add_collaborators" do
      it "does returns collaborators to a heroku app", :unit
    end
  end
end
