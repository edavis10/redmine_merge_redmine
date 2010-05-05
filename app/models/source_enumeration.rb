class SourceEnumeration < ActiveRecord::Base
  include SecondDatabase
  set_table_name :enumerations

  def self.migrate_issue_priorities
    all(:conditions => {:type => "IssuePriority"}) .each do |source_issue_priority|
      next if IssuePriority.find_by_name(source_issue_priority.name)

      IssuePriority.create!(source_issue_priority.attributes)
    end
  end

  def self.migrate_time_entry_activities
    all(:conditions => {:type => "TimeEntryActivity"}) .each do |source_activity|
      next if TimeEntryActivity.find_by_name(source_activity.name)

      TimeEntryActivity.create!(source_activity.attributes)
    end
  end

  def self.migrate_document_categories
    all(:conditions => {:type => "DocumentCategory"}) .each do |source_document_category|
      next if DocumentCategory.find_by_name(source_document_category.name)

       DocumentCategory.create!(source_document_category.attributes)
    end
  end

end
