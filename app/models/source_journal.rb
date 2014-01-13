class SourceJournal < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}journals#{table_name_suffix}"

  belongs_to :journalized, :polymorphic => true
  belongs_to :issue, :class_name => 'SourceIssue', :foreign_key => :journalized_id
  belongs_to :user, :class_name => 'SourceUser', :foreign_key => 'user_id'
  
  def self.migrate
    all.each do |source_journals|

      journal = Journal.create!(source_journals.attributes) do |j|
        j.user = User.find_by_login(source_journals.user.login) if source_journals.user_id
        j.issue = Issue.find_by_subject(source_journals.issue.subject)
      end

      RedmineMerge::Mapper.add_journal(source_journals.id, journal.id)
    end
  end
end
