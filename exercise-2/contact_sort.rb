#!/usr/bin/env ruby

# run contact_sort.rb > results.html

require 'csv'

groups = {}
rows = CSV.read('./contacts.csv', headers: true)

rows.each do |row|
  data = {
    name: "#{row['First name']} #{row['Last name']}",
    email: row['Email address'],
    phone: row['Telephone']
  }

  if groups[row['Group']]
    groups[row['Group']] << data
  else
    groups[row['Group']] = [data]
  end
end

groups.sort_by { |g, _| g }.each do |group, contacts|
  puts "<h2>#{group}</h2>"
  puts '<table><tr><th>Name</th><th>Email</th><th>Phone</th></tr>'
  contacts.sort_by { |c| c[:name] }.each do |contact|
    puts "<tr><td>#{contact[:name]}</td><td>#{contact[:email]}</td>" \
         "<td>#{contact[:phone]}</td></tr>"
  end
  puts '</table>'
end
