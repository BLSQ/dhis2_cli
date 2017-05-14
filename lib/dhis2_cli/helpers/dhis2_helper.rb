#!/usr/bin/env ruby
require 'uri'
require 'dhis2'

# DHIS2 helper class
class DHIS2Helper
  def initialize(uri)
    uri = URI.parse(uri)
    @dhis2 = Dhis2::Client.new(url: "#{uri.scheme}://#{uri.host}/#{uri.path}",
                               user: uri.user,
                               password: uri.password)
  end

  def max_level
    levels.size
  end

  def levels
    @dhis2.organisation_unit_levels.list
  end

  def org_units(level)
    @dhis2.organisation_units.list(filter: "level:eq:#{level}",
                                   fields: %w(id displayName shortName
                                              openingDate parent),
                                   page_size: 100_000)
  end

  def create_org_unit(org_units)
    payload = org_units.map do |org_unit|
      { id:           org_unit.id,
        name:         org_unit.display_name,
        short_name:   org_unit.short_name,
        opening_date: org_unit.opening_date,
        parent_id:    org_unit.parent_id }
    end
    @dhis2.organisation_units.create(payload)
  end
end
