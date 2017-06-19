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
  end

  desc 'add-to-group', 'add org units to a given group (creating it if not existing)'
  option :name, required: true
  option :filename, required: true
  option :dest, required: true
  def add_to_group
    dhis2_dest = DHIS2Helper.new options[:dest]

    group_name = options[:name]
    puts "Importing #{options[:filename]} in group #{group_name} of instance #{dhis2_dest.url}"

    group = dhis2_dest.find_or_create_group(group_name)
    org_unit_number_before = group.organisation_units.count

    org_units = CSV.read(options[:filename]).flatten

    puts "#{org_units.size} units found to be added"

    group = dhis2_dest.add_to_group(group, org_units)
    puts "Done. Group #{group.name} has now #{group.organisation_units.size} units (from #{org_unit_number_before}).".green
  end

  desc 'import', 'importing org units from csv file'
  option :file, required: true
  option :dest, required: true
  def import
    lines = CSV.read(options[:file], 'r')
    headers = lines.shift
    org_units_file = OrgUnitsFile.new(headers, lines)
    import_helper = ImportHelper.new options[:dest]
    import_helper.import org_units_file
   end
end
