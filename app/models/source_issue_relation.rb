class SourceIssueRelation < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}issue_relations#{table_name_suffix}"

  belongs_to :issue_from, :class_name => 'SourceIssue', :foreign_key => 'issue_from_id'
  belongs_to :issue_to, :class_name => 'SourceIssue', :foreign_key => 'issue_to_id'
  
  def self.migrate
    all.each do |source_issue_relation|

      IssueRelation.create!(source_issue_relation.attributes) do |ir|
        ir.issue_from = Issue.find_by_subject(source_issue_relation.issue_from.subject)
        ir.issue_to = Issue.find_by_subject(source_issue_relation.issue_to.subject)
      end
    end
  end
end
