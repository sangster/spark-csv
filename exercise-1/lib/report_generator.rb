# Generates and prints the Contacts report for a given collection of contacts.
class ReportGenerator
  QA_COLUMNS = %i[how_did_you_hear_about_us what_is_your_budget
                  what_is_your_favourite_color].freeze

  TEMPLATE = <<-REPORT.gsub(/^\s+/, '').freeze
    VALID CONTACTS
    ============================================================================
    %<valid>s
  REPORT

  attr_reader :contacts

  def initialize(contacts, output = $stderr)
    @contacts = contacts
    @output = output
  end

  def to_s
    format(
      TEMPLATE,
      valid: merge(complete_contacts).map(&method(:render_contact)).join("\n\n")
    )
  end

  # @return [Array<hash>] the list of contacts with no empty attributes
  #   (ignoring [QA_COLUMNS])
  def complete_contacts
    contacts.select do |contact|
      (contact.keys - QA_COLUMNS).none? { |col| contact[col].to_s.empty? }
    end
  end

  # Merges a list of contacts such that entries with the same email are merged
  # into a single element, with values from more recent entries taking
  # precidence.
  #
  # @param [Array<Hash>] the list of contacts
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

  def render_contact(contact)
    key_len = contact.keys.map { |k| k.to_s.size }.max

    contact.map do |key, value|
      format(
        '%<key>s: %<value>s',
        key: key.to_s.split('_').map(&:capitalize).join(' ').rjust(key_len),
        value: value.to_s.empty? ? '<N/A>' : value
      )
    end.join("\n")
  end
end
