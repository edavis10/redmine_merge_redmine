class SourceJournal < ActiveRecord::Base
  include SecondDatabase
  set_table_name :journals

  belongs_to :journalized, :polymorphic => true
  belongs_to :issue, :class_name => 'SourceIssue', :foreign_key => :journalized_id
  
  def self.migrate
    all.each do |source_journals|

      j = Journal.new
      j.attributes = source_journals.attributes
      j.issue = Issue.find_by_subject(source_journals.issue.subject)
      j.save!
    end
  end
end
