$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
require 'byebug'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'csv_reader'
require 'report_generator'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require 'files/processed_csv'
class UnitTest < Minitest::Test
  include ProcessedCsv

  protected

  def test_file(filename)
    Pathname.new(__FILE__).join('../files/').join(filename)
  end
end
