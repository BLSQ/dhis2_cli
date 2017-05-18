require 'csv'
# Representing a entity file to be imported
class EntityFile
  def initialize(file_path)
    @file_path = file_path
    @headers = CSV.open(@file_path, 'r', &:first)
    lines = CSV.read(@file_path)
    lines.shift
    @entities = lines.each_with_index.map do |entity_line, index|
      OpenStruct.new Hash[@headers.zip entity_line].merge(line_number: index + 1)
    end
  end

  def entities
    orgunits = levels[0..-1].map do |level_header|
      @entities.map { |entity| OrgUnitCandidate.new(entity, level_header) }.uniq
    end.flatten
    orgunits_by_name_level = orgunits.map { |orgunit| [[orgunit.level, orgunit.name], orgunit] }.to_h
    @entities.map do |entity|
      previous_parent = nil
      levels.each do |level_header|
        name = entity[level_header]
        level = level_header.gsub('level_', '').to_i
        parent = orgunits_by_name_level[[level.to_s, name]]
        child = OrgUnitCandidate.new(entity, level_header)

        if level_header == levels.last
          child = OrgUnitCandidate.new(entity, level_header)
          previous_parent.add_child(child)
        elsif previous_parent
          previous_parent.add_child(parent)
        end
        previous_parent = parent
      end
    end
    orgunits.select { |orgunit| orgunit.level.to_i == 1 }
  end

  def levels
    @headers.select { |header|  header.start_with?('level') }
  end
end
