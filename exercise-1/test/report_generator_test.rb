require 'helper'

class ReportGeneratorTest < UnitTest
  DUPE_EMAILS = %w[woodrowdbrown@mailinator.com magpads@gmail.com
                   mariojmclemore@mailinator.com mkessler@welchandsons.net]

  def test_complete_contacts__size
    report = ReportGenerator.new(contacts_hash)
    refute_equal contacts_hash.size, report.complete_contacts.size

    assert_equal 30, report.complete_contacts.size
  end

  def test_group_by_email__duplicate_entries
    report = ReportGenerator.new(contacts_hash)
    groups = report.group_by_email(report.complete_contacts)

    dupes = groups.select { |_, dupes| dupes.size > 1 }

    assert_equal DUPE_EMAILS, dupes.keys
  end

  def test_merge__duplicates_removed
    report = ReportGenerator.new(contacts_hash)
    merged = report.merge(report.complete_contacts)

    DUPE_EMAILS.each do |email|
      assert merged.select { |contact| contact[:email] == email }.size == 1,
             "Expected #{email} to only have one row in the merged table"
    end
  end

  def test_merge__examine_single_entry
    report = ReportGenerator.new(contacts_hash)
    merged = report.merge(report.complete_contacts)

    contact = merged.find { |c| c[:email] == 'woodrowdbrown@mailinator.com' }

    assert_equal 'Woodrow', contact[:first_name]
    assert_equal 'Brown', contact[:last_name]
    assert_equal 'woodrowdbrown@mailinator.com', contact[:email]
    assert_equal '905-338-1135', contact[:phone]
    assert_equal '479 Ari Ridges', contact[:address_line_1]
    assert_equal 'Terrace', contact[:city]
    assert_equal 'BC', contact[:province]
    assert_equal 'Canada', contact[:country_name]
    assert_equal 'V8G 1S2', contact[:postcode]
    assert_equal '2014-06-16 1329:08 UTC', contact[:date_added]
    assert_equal 'Google', contact[:how_did_you_hear_about_us]
    assert_equal '$200-$299', contact[:what_is_your_budget]
    assert_equal 'Green', contact[:what_is_your_favourite_color]
  end
end
