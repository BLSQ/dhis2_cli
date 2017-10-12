require "thor"
require "dhis2"
require "byebug"
require "platform-api"
require_relative "dhis2_cli/commands/org_unit"
require_relative "dhis2_cli/commands/heroku"
require_relative "dhis2_cli/helpers/heroku_setup_helper"
require_relative "dhis2_cli/commands/data_value"
require_relative "dhis2_cli/models/import/org_unit_candidate"
require_relative "dhis2_cli/helpers/org_units_helper"
require_relative "dhis2_cli/helpers/data_values_helper"
require_relative "dhis2_cli/helpers/data_element_import"
require_relative "dhis2_cli/helpers/dhis2_helper"
require_relative "dhis2_cli/models/import/org_units_file"
require_relative "dhis2_cli/models/import/org_unit_candidate"
require_relative "dhis2_cli/models/import/data_element_file"
require_relative "dhis2_cli/models/import/data_values_file"

module Dhis2
  module Api
    class OrganisationUnitGroupSet < Base
      class << self
        def create(client, orgunit_group_sets)
          orgunit_group_sets = [orgunit_group_sets].flatten
          response = client.post("metadata",
                                 organisation_unit_group_sets: orgunit_group_sets)
          Dhis2::Status.new(response)
        end
      end
    end
  end
end

module Dhis2Cli
  # Startup class
  class Cli < Thor
    register(OrgUnit, "orgunit", "orgunit <command>", "orgunit operations")
    register(Heroku, "heroku", "heroku <command>", "heroku operations")
    register(DataValue, "datavalue", "datavalue <command>", "datavalue operations")
  end
end
