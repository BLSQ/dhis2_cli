#!/usr/bin/env ruby
require 'uri'
require 'dhis2'

# DHIS2 helper class
class DHIS2Helper
  attr_reader :url, :client

  def initialize(uri)
    uri = URI.parse(uri)
    @url = "#{uri.scheme}://#{uri.host}/#{uri.path}"
    @client = Dhis2::Client.new(url: url,
                                user: uri.user,
                                password: uri.password)
  end

  def max_level
    levels.size
  end

  def find_group_by_name(name)
    @client.organisation_unit_groups.find_by(name: name)
  end

  def add_to_group(group, org_units)
    org_units.each_with_index do |ou_id, index|
      puts "Adding organisation unit #{ou_id} (#{index + 1}/#{org_units.size})"
      begin
        group.add_relation('organisationUnits', ou_id)
      rescue
        puts "Organisation unit #{ou_id} not found, passing"
      end
    end

    find_group_by_name(group.name)
  end

  def find_or_create_group(name)
    group = @client.organisation_unit_groups.find_by(name: name)

    if group
      puts "Existing group: #{group.name} with #{group.organisation_units.size} units will be updated"
    else
      puts "Group #{name} does not exist, creating"

      if create_group(name)
        group = @client.organisation_unit_groups.find_by(name: name)
        puts "Group #{name} created."
      else
        puts "Unable to create group #{name}. Exiting.".red
        exit
      end
    end

    group
  end

  def create_group(name)
    org_unit_groups = { name: name, short_name: name[0..20] }
    @client.organisation_unit_groups.create(org_unit_groups).success?
  end

  def levels
    @client.organisation_unit_levels.list
  end

  def org_units(level)
    @client.organisation_units.list(filter: "level:eq:#{level}",
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
    @client.organisation_units.create(payload)
  end
end
