class SourceIssueStatus < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}issue_statuses#{table_name_suffix}"

  def self.migrate
    all.each do |source_issue_status|
      next if IssueStatus.find_by_name(source_issue_status.name)

      IssueStatus.create!(source_issue_status.attributes)
    end
  end
end
