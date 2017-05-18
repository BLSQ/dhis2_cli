# frozen_string_literal: true

class DataElementImportHelper
  def initialize(dhis2)
    @dhis2 = dhis2
  end

  def import(data_element_file)
    elements = candidates(all_existing_elements, data_element_file.data_elements)

    create_missing(elements)

    elements = candidates(all_existing_elements, data_element_file.data_elements)

    to_csv(elements)
    elements
  end

  def all_existing_elements
    @dhis2.data_elements.list(page_size: 100_000)
  end

  def to_csv(elements)
    csv_string = CSV.generate do |csv|
      headers = %i[dhis2_id data_set_name de_name value ignored]
      csv << headers
      elements.each do |to_create|
        csv << headers.map { |k| to_create[k] }
      end
    end
    puts csv_string
  end

  def create_missing(elements)
    to_create = elements.select { |de| de.dhis2_id.nil? }.map do |de|
      {
        code: de.de_name[0..49],
        name: de.de_name,
        short_name: de.de_name[0..49],
        domainType: 'AGGREGATE',
        value_type: 'INTEGER',
        zeroIsSignificant: true
      }
    end
    puts "to create : #{to_create.size}"
    to_create.each_slice(10) do |slice|
      status = @dhis2.data_elements.create(slice)
      puts JSON.pretty_generate(status.raw_status)
    end
  end

  def candidates(existing_elements, candidates)
    existing_elements_by_name = index_by(existing_elements, :display_name)
    existing_elements_by_id = index_by(existing_elements, :id)

    candidates.map do |de_candidate|
      # workaround to have an idempotent csv (without prefix-suffix)
      if de_candidate.prefix || de_candidate.name
        de_name = [de_candidate.prefix, de_candidate.name].compact.join(' ')
        de_candidate[:de_name] = de_name
      end

      unless de_candidate.dhis2_id
        el = existing_elements_by_name[de_candidate.de_name]
        de_candidate.dhis2_id ||= el.id if el
      end

      next unless valid(de_candidate)

      de_candidate[:value] = de_candidate.value.to_s.delete('F').delete(',').strip.to_i if de_candidate.value

      de_candidate
    end.compact
  end

  def valid(de)
    puts "too long #{de_candidate}" if de.de_name.size > 199
    de.data_set_name != '' && !de.data_set_name.nil? && !de.de_name.nil? && de.de_name.size <= 199
  end

  def index_by(hash, prop)
    Hash[hash.map { |elem| [elem[prop], elem] }]
  end
end
