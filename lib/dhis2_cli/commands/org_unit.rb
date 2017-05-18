require_relative '../helpers/dhis2_helper'
require_relative '../helpers/import_helper'

# OrgUnit command
class OrgUnit < Thor
  desc 'copy', 'copy orgunits from one instance to another'
  option :source, required: true
  option :dest, required: true
  def copy
    dhis2_source = DHIS2Helper.new options[:source]
    dhis2_dest = DHIS2Helper.new options[:dest]
    (1..dhis2_source.max_level).each do |level|
      source_org_units = dhis2_source.org_units(level)
      puts "Importing level #{level}"
      puts dhis2_dest.create_org_unit(source_org_units).inspect
    end

  desc 'import', 'import'
  option :file, required: true
  def import  
    # chargement du header meta 
    end
  end
end
