# Representing a entity file to be imported
class OrgUnitsFile
  attr_reader :headers, :lines, :candidates

  def initialize(filepath, headers, lines)
    @filepath = filepath
    @headers = headers
    @lines = lines
    build_candidates
  end

  def level_headers
    @level_headers ||= @headers.select { |header| header.start_with?('level') }
  end

  def groupset_headers
    @group_headers ||= @headers.select { |header| header.start_with?('groupset') }
  end

  def candidate_lines
    @candidate_lines ||= @lines.each_with_index.map do |line, idx|
      OpenStruct.new Hash[@headers.zip line].merge(line_number: idx + 1)
    end
  end

  def root
    @root ||= build_flattened_tree.select do |candidate|
      candidate.level.to_i == 1
    end.first
  end

  def leafs
    @candidates.map { |candidate| candidate if candidate.facility }.compact
  end

  def export
    leafs.sort_by { |candidate| candidate.entity.line_number }
         .map { |candidate| [candidate.dhis2_path, candidate.entity.to_h.values].flatten }
  end

  private

  def build_candidates
    level_headers[0..-1].map do |level_header|
      is_facility = (@level_headers.last == level_header)
      candidate_lines.map do |candidate_line|
        OrgUnitCandidate.new(candidate_line, level_header, is_facility)
      end.uniq
    end.flatten
  end

  def build_flattened_tree
    return @candidates if @candidates
    @candidates = build_candidates
    candidates_by_level_name = @candidates.map do |candidate|
      [[candidate.level, candidate.name], candidate]
    end.to_h
    candidate_lines.map do |candidate_line|
      previous_parent = nil
      level_headers.each do |level_header|
        name = candidate_line[level_header]
        level = level_header.gsub('level_', '').to_i
        parent = candidates_by_level_name[[level.to_s, name]]
        if level_header == level_headers.last
          child = candidates_by_level_name[[level.to_s, name]]
          previous_parent.add_child(child)
        elsif previous_parent
          previous_parent.add_child(parent)
        end
        previous_parent = parent
      end
    end
    @candidates
  end
end
