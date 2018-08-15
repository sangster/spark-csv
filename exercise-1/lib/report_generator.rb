# Generates and prints the Contacts report for a given collection of contacts.
class ReportGenerator
  QA_COLUMNS = %i[how_did_you_hear_about_us what_is_your_budget
                  what_is_your_favourite_color].freeze

  TEMPLATE = <<-TEMPLATE.gsub(/^ {4}/, '').freeze
    Report
    ============================================================================
         Total Contacts: %<total_size>d
     Duplicate Contacts: %<duplicate_size>d
    Incomplete Contacts: %<incomplete_size>d

    Valid Contacts
    ============================================================================
    %<valid>s

    Invalid Contacts
    ============================================================================
    %<invalid>s
  TEMPLATE

  attr_reader :contacts

  # @param contacts [Array<hash>] the list of contacts to report on
  # @param output [IO] where to write the report to
  def initialize(contacts, output = $stderr)
    @contacts = contacts
    @output = output
  end

  def to_s
    format(
      TEMPLATE,
      total_size: contacts.size,
      duplicate_size: duplicate_size,
      incomplete_size: incomplete_contacts.size,
      valid: merge(complete_contacts).map(&method(:contact_to_s)).join("\n\n"),
      invalid: invalid_report
    )
  end

  # @return [Array<hash>] the list of contacts with no empty attributes
  #   (ignoring [QA_COLUMNS])
  def complete_contacts
    contacts.select do |contact|
      (contact.keys - QA_COLUMNS).none? { |col| contact[col].to_s.empty? }
    end
  end

  def incomplete_contacts
    contacts - complete_contacts
  end

  # Merges a list of contacts such that entries with the same email are merged
  # into a single element, with values from more recent entries taking
  # precidence.
  #
  # @param contacts_with_dupes [Array<Hash>] the list of contacts
  # @return [Array<Hash>] the same list of contacts, with duplicate entries
  #   merged into one
  def merge(contacts_with_dupes)
    group_by_email(contacts_with_dupes).flat_map do |_, contacts|
      contacts.sort_by! { |c| c[:date_added] }

      contacts.first.tap do |merged|
        contacts[1..-1].each do |newer|
          merged.keys.each do |key|
            merged[key] = newer[key] unless newer[key].to_s.empty?
          end
        end
      end
    end
  end

  # @return [Hash<String, Array<Hash>>] all the given contacts, grouped by
  #   shared email address
  def group_by_email(contacts)
    Hash.new { |hash, key| hash[key] = [] }.tap do |groups|
      contacts.each { |contact| groups[contact[:email]] << contact }
    end
  end

  # @return [String] A nicely-formated representation of the given contact
  def contact_to_s(contact)
    key_len = contact.keys.map { |k| k.to_s.size }.max

    contact.map do |key, value|
      format(
        '%<key>s: %<value>s',
        key: key.to_s.split('_').map(&:capitalize).join(' ').rjust(key_len),
        value: value.to_s.empty? ? '<N/A>' : value
      )
    end.join("\n")
  end

  def duplicate_size
    group_by_email(contacts).select { |_, c| c.size > 1 }.size
  end

  def invalid_report
    incomplete = incomplete_contacts

    errors =
      contacts.each_with_index.map do |contact, index|
        next unless incomplete.include?(contact)

        missing =
          (contact.keys - QA_COLUMNS).select { |col| contact[col].to_s.empty? }

        format(
          'Row %<row>d: Blank column%<plural>s: %<cols>s',
          row: index + 2, # 2 accounts for header + 0-index
          cols: missing.map(&:to_s).join(', '),
          plural: missing.size == 1 ? '' : 's'
        )
      end

    errors.compact.join("\n")
  end
end
