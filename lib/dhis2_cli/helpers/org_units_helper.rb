
class OrgUnitsHelper
  def initialize(uri)
    @dhis2_helper = DHIS2Helper.new uri
  end

  def import(org_units_file, file_name = "org_units_import.csv")
    traverse(org_units_file.root) do |candidate|
      puts (" -- " * candidate.level.to_i) + " " + candidate.name + " #{candidate.children.size}"
    end

    update_or_create_groupsets(org_units_file)

    traverse(org_units_file.root) do |candidate|
      save_candidate candidate
      update_groups(candidate, org_units_file.groupset_headers) if candidate.facility
    end
    export(org_units_file, file_name)
  end

  def export(org_units_file, file_name)
    CSV.open(file_name, "wb") do |csv|
      org_units_file.export.each { |line| csv << line }
    end
  end

  def traverse(candidate, &block)
    yield candidate
    candidate.children.each do |child|
      traverse(child, &block) if candidate.children
    end
  end

  private

  def update_or_create_groupsets(org_units_file)
    org_units_file.groupset_headers.each do |group_set_header|
      group_set_name = group_set_header.split(":")[1]
      group_set = @dhis2_helper.client.organisation_unit_group_sets.find_by(name: group_set_name)
      unless group_set
        @dhis2_helper.client.organisation_unit_group_sets.create(name: group_set_name)
        group_set = @dhis2_helper.client.organisation_unit_group_sets.find_by(name: group_set_name)
      end
      group_names = Set.new
      traverse(org_units_file.root) do |candidate|
        group_names.add(candidate.entity[group_set_header])
      end
      puts " #{group_set_name} => #{group_names.to_a}"
      groups = group_names.map { |group_name| @dhis2_helper.find_or_create_group(group_name) }

      groups.each do |group|
        group_set.organisation_unit_groups.push(id: group.id)
      end
      group_set.update
    end
  end

  def save_candidate(candidate)
    puts "\n********** #{candidate.name}"
    org_unit = {
      name:         candidate.name,
      short_name:   candidate.name,
      opening_date: "1970-1-1"
    }

    org_unit[:id] = candidate.dhis2_id if candidate.exist_in_dhis2?
    org_unit[:parent_id] = candidate.parent.dhis2_id if candidate.parent
    org_unit[:opening_date] = candidate.opening_date if candidate.facility && candidate.opening_date
    if candidate.dhis2_id.nil?
      query = { level: candidate.level, name: candidate.name }
      query["parent.id"] = candidate.parent.dhis2_id if candidate.parent && candidate.parent.dhis2_id
      existing = @dhis2_helper.client.organisation_units.find_by(query)

      if existing
        candidate.dhis2_id = existing.id
        puts "found #{existing.dhis2_id} #{existing.name} for #{candidate.dhis2_path}"
        org_unit.each do |attribute, value|
          puts "updating : #{attribute} #{value} "
          existing[attribute] = value
        end
        existing.update
      else
        puts " creating #{org_unit}"
        status = @dhis2_helper.client.organisation_units.create(org_unit)
        candidate.dhis2_id = status.last_imported_ids[0]
        created = @dhis2_helper.client.organisation_units.find_by(query)
        candidate.dhis2_id = created.id
        puts "   status : #{status.raw_status.to_json}"
        puts " creating #{org_unit} #{candidate.dhis2_id}"
      end
    end
  rescue => e
    puts "!!"
    puts "failed to save #{e.class} #{e.message}\n   #{candidate.name}\n #{e.backtrace}"
  end

  def update_groups(candidate, groupset_headers)
    groupset_headers.each do |groupset_header|
      group_name = candidate.entity[groupset_header]
      group = @dhis2_helper.find_or_create_group(group_name)
      @dhis2_helper.add_to_group(group, [candidate.dhis2_id])
      # add group to groupset if not the case
    end
  end
end
