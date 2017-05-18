
class ImportHelper
  
  def initialize
  @client = Dhis2::Client.new(url: '', 
                              user: '', 
                              password: '')
  @leaves = []
  end 

  def import(entity_file)
    root = entity_file.entities
    puts root[0].name
    #traverse root[0]
    export(root[0])
  end
  
  def export org_unit
    find_last_level(org_unit)    
    @leaves.sort_by {|candidate| candidate.entity.line_number}
    CSV.generate do |csv|
        @leaves.each do |candidate|
          csv << [candidate.dhis2_id, candidate.entity.name]
        end 
    end 
    result > csv
  end 


  def traverse(orgunit)
    create_org_unit(orgunit) 
    puts orgunit.dhis2_path
    orgunit.children.each { |child| traverse child } if orgunit.children
   end

  def find_last_level(orgunit)
    @leaves.push(orgunit) if orgunit.level == "4"
    orgunit.children.each { |child| find_last_level child } if orgunit.children
  end 

    
  def create_org_unit orgunit 
    unless orgunit.dhis2_id
      org_unit = { name: orgunit.name, 
                   short_name: orgunit.name, 
                   opening_date: "2016-09-30"}
      org_unit[:parent_id] = orgunit.parent.dhis2_id if orgunit.parent 
      status = @client.organisation_units.create(org_unit);
      orgunit.dhis2_id = status.last_imported_ids[0]
    end
  end 
end
