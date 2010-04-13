class SourceEnumeration < ActiveRecord::Base
  include SecondDatabase
  set_table_name :enumerations

  def self.migrate_issue_priorities
    all(:conditions => {:type => "IssuePriority"}) .each do |source_issue_priority|
      next if IssuePriority.find_by_name(source_issue_priority.name)

      p = IssuePriority.new(source_issue_priority.attributes)
      p.save!
    end
  end

  def self.migrate_time_entry_activities
    all(:conditions => {:type => "TimeEntryActivity"}) .each do |source_activity|
      next if TimeEntryActivity.find_by_name(source_activity.name)

      a = TimeEntryActivity.new(source_activity.attributes)
      a.save!
    end
  end

  def self.migrate_document_categories
    all(:conditions => {:type => "DocumentCategory"}) .each do |source_document_category|
      next if DocumentCategory.find_by_name(source_document_category.name)

      dc = DocumentCategory.new(source_document_category.attributes)
      dc.save!
    end
  end

end
