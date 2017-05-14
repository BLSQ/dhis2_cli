require 'thor'
require_relative 'dhis2_cli/commands/org_unit'
require_relative 'dhis2_cli/commands/heroku'

module Dhis2Cli
  # Startup class
  class Cli < Thor
    register(OrgUnit, 'orgunit', 'orgunit <command>', 'orgunit operations')
    register(Heroku, 'heroku', 'heroku <command>', 'heroku operations')
  end
end
