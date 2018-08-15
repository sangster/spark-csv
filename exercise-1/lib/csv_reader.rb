require 'csv'
require 'pathname'

# Reads a CSV file from a given path and returns its rows as an array of hashes.
class CsvReader
  extend Forwardable
  include Enumerable

  attr_reader :path
  def_delegators :to_a, :each, :size, :-

  # @param [Pathname, #to_s] the path to the CSV file to read
  def initialize(path)
    @path = path
  end

  # @return [Array<Hash<Symbol, String>]
  def to_a
    @to_a ||= parser(read_csv).map(&:to_h)
  end

  private

  def parser(body)
    CSV.parse(body, headers: true, header_converters: :symbol)
  end

  def read_csv
    path.is_a?(Pathname) ? path.read : IO.read(path)
  end
end
