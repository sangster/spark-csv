require 'helper'

class CsvReaderTest < UnitTest
  def test_to_a__size
    reader = CsvReader.new(test_file('contacts.csv'))
    assert_equal 33, reader.to_a.size
  end

  def test_each__keys
    reader = CsvReader.new(test_file('contacts.csv'))
    reader.each do |row|
      assert_equal %i[first_name last_name email phone address_line_1 city
                      province country_name postcode date_added
                      how_did_you_hear_about_us what_is_your_budget
                      what_is_your_favourite_color],
                   row.keys
    end
  end
end
