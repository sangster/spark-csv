#!/usr/bin/env ruby
require 'csv'

INFILE = ARGV.size == 0 ? './contacts.csv' : ARGV[0]

require 'byebug'

groups = Hash.new { |hash, key| hash[key] = [] }

CSV.read(INFILE, headers: true).each do |row|
  groups[row['Group']] << {
    name: "#{row['First name']} #{row['Last name']}",
    email: row['Email address'],
    phone: row['Telephone']
  }
end

groups.sort.to_h.each do |group, contacts|
  puts "<h2>#{group}</h2>"
  puts '<table><tr><th>Name</th><th>Email</th><th>Phone</th></tr>'

  contacts.sort_by { |c| c[:name] }.each do |contact|
    puts "<tr><td>#{contact[:name]}</td><td>#{contact[:email]}</td>" \
         "<td>#{contact[:phone]}</td></tr>"
  end

  puts '</table>'
end
