require 'thor'
require 'dhis2'
require 'byebug'
require 'platform-api'
require_relative 'dhis2_cli/commands/org_unit'
require_relative 'dhis2_cli/commands/heroku'
require_relative 'dhis2_cli/helpers/heroku_setup_helper'
require_relative 'dhis2_cli/helpers/import_helper'
require_relative 'dhis2_cli/models/import/entity_file'
require_relative 'dhis2_cli/models/import/org_unit_candidate'
require_relative 'dhis2_cli/helpers/org_units_helper'
require_relative 'dhis2_cli/helpers/data_element_import'
require_relative 'dhis2_cli/helpers/dhis2_helper'
require_relative 'dhis2_cli/models/import/org_units_file'
require_relative 'dhis2_cli/models/import/org_unit_candidate'
require_relative 'dhis2_cli/models/import/data_element_file'

module Dhis2Cli
  # Startup class
  class Cli < Thor
    register(OrgUnit, 'orgunit', 'orgunit <command>', 'orgunit operations')
    register(Heroku, 'heroku', 'heroku <command>', 'heroku operations')
  end
end
