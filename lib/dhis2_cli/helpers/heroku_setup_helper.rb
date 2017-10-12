require_relative "heroku_base_helper"
require "platform-api"

# DHIS2 Heroku helper
class HerokuSetupHelper < HerokuBaseHelper
  def initialize(token = nil)
    super(token)
  end

  # version et region dans le plan
  def create_app(app_name, db_plan)
    @heroku.app.create(name: app_name, region: { name: "eu" })
    @heroku.addon.create(app_name, "plan" => "heroku-postgresql:#{db_plan}")
  end

  def configure_dhis2_vars(app_name, custom_vars = {})
    vars = heroku.config_var.info_for_app(app_name)
    raise Exception, "DATABASE_URL not present" unless vars["DATABASE_URL"]
    uri = URI.parse(vars["DATABASE_URL"])
    updated_vars = { DATABASE_HOST:     uri.host,
                     DATABASE_NAME:     uri.path[1..-1],
                     DATABASE_PORT:     uri.port,
                     DATABASE_USER:     uri.user,
                     DATABASE_PASSWORD: uri.password,
                     DHIS2_HOME:        "." }.merge(custom_vars)
    heroku.config_var.update(app_name, updated_vars)
  end

  def deploy_dhis2_repo(app_name)
    `export dhis2_project_name=#{app_name}`
    `git clone git@bitbucket.org:bluesquare_org/dhis2-setup.git #{app_name}`
    Dir.chdir app_name
    git_url = heroku.app.info(app_name)["git_url"]
    `git remote add heroku #{git_url}`
    `git push heroku master`
    Dir.chdir ".."
    `rm -rf #{app_name}`
  end

  def restore_sql(app_name, sql_file)
    `heroku pg:psql --app #{app_name} < #{sql_file}`
  end
end
