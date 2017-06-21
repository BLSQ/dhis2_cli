class OrgUnitCandidate
  attr_reader :name, :level, :entity, :external_id, :children, :dhis2_path, :opening_date, :facility
  attr_accessor :parent, :dhis2_id

  def initialize(entity, level_header, is_facility)
    @entity = entity
    @name = entity[level_header]
    @level = level_header.gsub('level_', '')
    @children = Set.new
    @facility = is_facility
    @opening_date = entity[:opening_date] if @facility
  end

  def eql?(other)
    @name == other.name && @level == other.level
  end

  def hash
    [@name, @level].hash
  end

  def exist_in_dhis2?
    @dhis2_id
  end

  def leaf?
    @children
  end

  def add_child(child)
    @children.add(child)
    child.parent = self
  end

  def dhis2_path
    @dhis2_path ||= create_path(self)
  end

  def create_path(candidate)
    return candidate.dhis2_id unless candidate.parent
    create_path(candidate.parent) + '/' + candidate.dhis2_id
  end
end
