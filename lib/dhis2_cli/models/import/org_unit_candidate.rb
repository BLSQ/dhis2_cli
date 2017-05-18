class OrgUnitCandidate
  attr_reader :name, :level, :entity, :external_id, :children
  attr_accessor :parent, :dhis2_id

  
  def initialize(entity, level_header)
    @entity = entity
    @name = entity[level_header]
    @level = level_header.gsub('level_', '')
    @children = Set.new
    @dhis2_id = entity.dhis2_path.split('/')[@level] if entity.dhis2_path
  end

  def eql?(other)
    @name == other.name && @level == other.level
  end

  def hash
    [@name, @level].hash
  end

  def dhis2_exist?
    @dhis2_id
  end

  def add_child(child)
    @children.add(child) 
    child.parent = self
  end
  
  def dhis2_path()
     create_path(self) 
  end 

  def create_path(candidate)
    return candidate.dhis2_id unless candidate.parent 
    create_path(candidate.parent) + '/' + candidate.dhis2_id
  end
end
