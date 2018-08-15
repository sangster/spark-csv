#!/usr/bin/env ruby
require 'csv'
require 'erb'

INFILE = ARGV.empty? ? './contacts.csv' : ARGV[0]
TEMPLATE = ARGV.size < 2 ? './template.html.erb' : ARGV[1]

# Context provided to ERB template. This will expose the template to two local
# variables:
#  - group [String] the name of the current group of contacts
#  - contacts [Array<Hash>] the array of contacts in the given group
class ErbContext
  attr_reader :group, :contacts

  def initialize(template, group, contacts)
    @template = template
    @group = group
    @contacts = contacts
  end

  def to_s
    ERB.new(IO.read(@template), nil, '<>').result(binding)
  end
end

# @param csv_file [String] path of the CSV file to sort and render as HTML
# @param template [String] path of the ERB template used to render the HTML
def render_sorted(csv_file, template, output = $stdout)
  groups = group_contacts(CSV.read(csv_file, headers: true))

  # Render the HTML for each individual group
  groups.sort.to_h.each do |group, contacts|
    output.puts ErbContext.new(template, group, contacts)
  end
end

def group_contacts(contacts)
  Hash.new { |hash, key| hash[key] = [] }.tap do |groups|
    contacts.each do |row|
      groups[row['Group']] << {
        name: "#{row['First name']} #{row['Last name']}",
        email: row['Email address'],
        phone: row['Telephone']
      }
    end
  end
end

render_sorted(INFILE, TEMPLATE) if $PROGRAM_NAME == __FILE__
