#!/usr/bin/env ruby

require 'faker'
require 'csv'

GROUPS = %w[Group1 Group2 Group3 Group4].freeze

CSV.open('./contacts.csv', 'w+') do |csv|
  csv << ['First name', 'Last name', 'Email address', 'Telephone', 'Group']

  10_000.times do
    csv << [
      name = Faker::Name.first_name,
      Faker::Name.last_name,
      Faker::Internet.email(name),
      Faker::PhoneNumber.cell_phone,
      GROUPS.sample
    ]
  end
end
