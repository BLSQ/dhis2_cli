require 'thor'
require 'dhis2'
require 'byebug'
require_relative 'dhis2_cli/commands/org_unit'
require_relative 'dhis2_cli/commands/heroku'
require_relative 'dhis2_cli/helpers/import_helper'
require_relative 'dhis2_cli/models/import/entity_file'
require_relative 'dhis2_cli/models/import/org_unit_candidate'

module Dhis2Cli
  # Startup class
  class Cli < Thor
    register(OrgUnit, 'orgunit', 'orgunit <command>', 'orgunit operations')
    register(Heroku, 'heroku', 'heroku <command>', 'heroku operations')
  end
end
