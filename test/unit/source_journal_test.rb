require File.dirname(__FILE__) + '/../test_helper'

class SourceJournalTest < ActiveSupport::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload

      # Make sure Journals are associating correctly and not that they
      # just happen to match ids.
      @project = Project.generate!
      @tracker = Tracker.generate!
      @project.trackers << @tracker
      @enumeration = IssuePriority.generate!
      Issue.generate!(:tracker => @tracker, :project => @project, :priority => @enumeration)

      SourceUser.migrate
      SourceTracker.migrate
      SourceIssueStatus.migrate
      SourceEnumeration.migrate_issue_priorities
      SourceProject.migrate
      SourceVersion.migrate
      SourceIssueCategory.migrate
      SourceIssue.migrate

    end
    
    should_add_each_record_from_the_source_to_the_destination(Journal, 2) { SourceJournal.migrate }

    should "keep the issue associations" do
      SourceJournal.migrate
      
      issue = Issue.find_by_subject("Can't print recipes")
      assert issue
      assert_equal 2, issue.journals.count
      assert issue.journals.collect(&:notes).include? "Journal notes"
      assert issue.journals.collect(&:notes).include? "Some notes with Redmine links: #2, r2."
    end

  end
end
