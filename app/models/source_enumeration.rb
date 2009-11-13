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

  def self.migrate_time_entry_activities
    all(:conditions => {:opt => "ACTI"}) .each do |source_activity|
      next if Enumeration.activities.find_by_name(source_activity.name)

      a = Enumeration.new(:opt => "ACTI")
      a.attributes = source_activity.attributes
      a.save!
    end
  end

  def self.migrate_document_categories
    all(:conditions => {:opt => "DCAT"}) .each do |source_document_category|
      next if Enumeration.document_categories.find_by_name(source_document_category.name)

      dc = Enumeration.new(:opt => "DCAT")
      dc.attributes = source_document_category.attributes
      dc.save!
    end
  end

end
