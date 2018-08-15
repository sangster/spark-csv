#!/usr/bin/env ruby

require 'faker'
require 'csv'

OUTFILE = ARGV.size == 0 ? './contacts.csv' : ARGV[0]
ROW_SIZE = ARGV.size < 2 ? 10_000 : ARGV[1]
GROUPS = %w[Group1 Group2 Group3 Group4].freeze
HEADERS = ['First name', 'Last name', 'Email address', 'Telephone',
           'Group'].freeze


CSV.open(OUTFILE, 'w+') do |csv|
  csv << HEADERS

  ROW_SIZE.times do
    name = Faker::Name.first_name

    csv << [
      name,
      Faker::Name.last_name,
      Faker::Internet.email(name),
      Faker::PhoneNumber.cell_phone,
      GROUPS.sample
    ]
  end
end
