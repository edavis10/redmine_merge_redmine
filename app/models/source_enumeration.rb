class SourceEnumeration < ActiveRecord::Base
  include SecondDatabase
  set_table_name :enumerations

  def self.migrate_issue_priorities
    all(:conditions => {:opt => "IPRI"}) .each do |source_issue_priority|
      next if Enumeration.priorities.find_by_name(source_issue_priority.name)

      p = Enumeration.new(:opt => "IPRI")
      p.attributes = source_issue_priority.attributes
      p.save!
    end
  end
end
