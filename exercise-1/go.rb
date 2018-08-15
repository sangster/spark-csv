#!/usr/bin/env ruby

require_relative 'lib/csv_reader'
require_relative 'lib/report_generator'

if ARGV.size != 1
  warn "Usage: #{__FILE__} CSV_FILE"
  exit 1
end

reader = CsvReader.new(ARGV[0])
puts ReportGenerator.new(reader)
