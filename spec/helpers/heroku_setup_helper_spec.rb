require_relative '../../lib/dhis2_cli/helpers/heroku_setup_helper'

describe HerokuSetupHelper do
  let(:heroku) { HerokuSetupHelper.new }

  describe '#create_app' do
    it 'should create an app on heroku with selected database plan' do
      app_name = 'cli-test-app'
      expect { heroku.create_app(app_name, 'hobby-dev') }
        .to_not raise_error(Exception)
      `heroku destroy #{app_name} -c #{app_name}`
    end

    it 'should fail to create an app if app with same name already exist' do
      app_name = 'cli-test-app'
      heroku.create_app(app_name, 'hobby-dev')
      expect { heroku.create_app(app_name, 'hobby-dev') }
        .to raise_error(Exception)
      `heroku destroy #{app_name} -c #{app_name}`
    end
  end

  describe '#configure_app_variables' do
    it 'should add database variables to heroku app' do
      app_name = 'cli-test-app'
      heroku.create_app(app_name, 'hobby-dev')
      expect { heroku.configure_dhis2_vars(app_name) }
        .to_not raise_error(Exception)
      `heroku destroy #{app_name} -c #{app_name}`
    end

    it 'should fail if app is not existing' do
      expect { heroku.configure_dhis2_vars('not_existing_app') }
        .to raise_error(Exception)
    end
  end

  describe '#deploy' do
    it 'should deploy dhis2 repo on heroku app'
  end
end
