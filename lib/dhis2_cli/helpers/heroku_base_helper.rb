require 'platform-api'
# Heroku Helper
class HerokuBaseHelper
  attr_reader :token
  attr_reader :heroku

  SUPPORTED_DB_PLAN = ['hobby-dev', 'hobby-basic'].freeze
  SUPPORTED_DHIS2 = ['2.21', '2.22', '2.23', '2.24', '2.25', '2.26'].freeze

  def initialize(token = nil)
    @token = token || ENV['HEROKU_TOKEN']
    @collaborators = ENV['DHIS2_CLI_COLLABORATORS'] || []
    @heroku = PlatformAPI.connect_oauth(@token)
  end

  def valid_app_name?(app_name)
    !!(app_name =~ /^[a-z][a-z0-9-]{2,29}$/)
  end

  def valid_db_plan?(db_plan)
    SUPPORTED_DB_PLAN.include? db_plan
  end

  def valid_dhis2_version?(dhis2_version)
    SUPPORTED_DHIS2.include? dhis2_version
  end

  def add_collaborators(app_name)
    @collaborators.split(',').each do |email|
      heroku.collaborator.create(app_name,
                                 'user' => { 'email' => email.to_s })
    end
  end
end
