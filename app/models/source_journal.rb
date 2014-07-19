class SourceJournal < ActiveRecord::Base
  include SecondDatabase
  set_table_name :journals

  belongs_to :journalized, :polymorphic => true
  belongs_to :issue, :class_name => 'SourceIssue', :foreign_key => :journalized_id
  
  def self.migrate
    all.each do |source_journals|

      journal = Journal.create!(source_journals.attributes) do |j|
        j.issue = Issue.find_by_subject(source_journals.issue.subject)
        j.user_id = RedmineMerge::Mapper.get_new_user_id(source_journals.user_id)
      end

      RedmineMerge::Mapper.add_journal(source_journals.id, journal.id)
    end
  end
end
