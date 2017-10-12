# require_relative '../helpers/heroku_setup_helper'
require "thor"
require "colorize"

# OrgUnit command
class Heroku < Thor
  no_commands do
    def validate_install_args(options)
      heroku = HerokuSetupHelper.new
      unless heroku.valid_app_name?(options[:name])
        puts "Invalid app name"
        exit(1)
      end
      unless heroku.valid_db_plan?(options[:db_plan])
        puts "Invalid db plan"
        exit(1)
      end
      unless heroku.valid_dhis2_version?(options[:version])
        puts "Invalid dhis2 version"
        exit(1)
      end
    end
  end

  desc "install", "Create Heroku app with name and install dhis2 instance"
  option :name, required: true, desc: "name of the application on heroku"
  option :port, default: "80", desc: "tcp port on which dhis2 will respond"
  option :db_plan, default: "hobby-basic", desc: "heroku postgres database plan"
  option :version, default: "2.25", desc: "version of dhis2 to install"
  option :country_code, desc: "country code used for dhis2 assets"
  option :sql_file, desc: "sql file to be loaded"
  def install
    validate_install_args(options)
    heroku = HerokuSetupHelper.new
    heroku.create_app(options[:name], options[:db_plan])
    custom_vars = { PORT:          options[:port],
                    DHIS2_VERSION: options[:version].tr(".", ""),
                    COUNTRY_CODE:  options[:country_code] }
    heroku.configure_dhis2_vars(options[:name], custom_vars)
    puts "Heroku app #{options[:name]} created and configured".green
    heroku.restore_sql(options[:name], options[:sql_file]) if options[:sql_file]
    puts "Sql file #{options[:sql_file]} loaded".green
    heroku.deploy_dhis2_repo(options[:name])
    puts "Git repository deployed".green
    heroku.add_collaborators(options[:name])
    puts "Collaborators added".green
  end
end
