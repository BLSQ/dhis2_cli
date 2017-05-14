require_relative '../../lib/dhis2_cli/helpers/heroku_base_helper'

describe HerokuBaseHelper do
  let(:heroku) { HerokuBaseHelper.new }

  describe 'valid_app_name?' do
    it 'should return true if app name is valid' do
      expect(heroku.valid_app_name?('valid-name')).to eq true
    end

    it 'should return false if app name is not valid' do
      expect(heroku.valid_app_name?('invalid_name')).to eq false
    end
  end

  describe 'valid_db_plan?' do
    it 'should return true if db plan is valid' do
      expect(heroku.valid_db_plan?('hobby-dev')).to eq true
    end

    it 'should return false if db plan is not valid' do
      expect(heroku.valid_db_plan?('invalid-db-plan')).to eq false
    end

    describe '#add_collaborators' do
      it 'should add collaborators to a heroku app'
    end
  end
end
