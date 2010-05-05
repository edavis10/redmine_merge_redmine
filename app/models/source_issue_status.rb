class SourceIssueStatus < ActiveRecord::Base
  include SecondDatabase
  set_table_name :issue_statuses

  def self.migrate
    all.each do |source_issue_status|
      next if IssueStatus.find_by_name(source_issue_status.name)

      IssueStatus.create!(source_issue_status.attributes)
    end
  end
end
