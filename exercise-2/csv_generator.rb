#!/usr/bin/env ruby
require 'faker'
require 'csv'

GROUPS = %w[Group1 Group2 Group3 Group4].freeze
HEADERS = ['First name', 'Last name', 'Email address', 'Telephone',
           'Group'].freeze

OUTFILE = ARGV.empty? ? './contacts.csv' : ARGV[0]
ROW_SIZE = ARGV.size < 2 ? 10_000 : ARGV[1].to_i

def faker_row
  name = Faker::Name.first_name
  [
    name,
    Faker::Name.last_name,
    Faker::Internet.email(name),
    Faker::PhoneNumber.cell_phone,
    GROUPS.sample
  ]
end

CSV.open(OUTFILE, 'w+') do |csv|
  csv << HEADERS
  ROW_SIZE.times { csv << faker_row }
end
