
class OrgUnitsHelper
  def initialize(uri)
    @dhis2_helper = DHIS2Helper.new uri
  end

  def import(org_units_file, file_name = 'org_units_import.csv')
    traverse(org_units_file.root) do |candidate|
      save_candidate candidate
      update_groups(candidate, org_units_file.groupset_headers) if candidate.facility
    end
    export(org_units_file, file_name)
  end

  def export(org_units_file, file_name)
    CSV.open(file_name, 'wb') do |csv|
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

  def save_candidate(candidate)
    org_unit = { name: candidate.name,
                 short_name: candidate.name,
                 opening_date: '1970-01-01' }

    org_unit[:id] = candidate.dhis2_id if candidate.exist_in_dhis2?
    org_unit[:parent_id] = candidate.parent.dhis2_id if candidate.parent
    org_unit[:opening_date] = candidate.opening_date if candidate.facility

    status = @dhis2_helper.client.organisation_units.create(org_unit)
    candidate.dhis2_id = status.last_imported_ids[0]
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
