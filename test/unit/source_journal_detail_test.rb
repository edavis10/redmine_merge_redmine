require File.dirname(__FILE__) + '/../test_helper'

class SourceJournalDetailTest < ActiveSupport::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload

      # Make sure objects associating correctly and not that they just
      # happen to match ids.
      @project = Project.generate!
      @tracker = Tracker.generate!
      @project.trackers << @tracker
      @enumeration = IssuePriority.generate!
      @issue = Issue.generate!(:tracker => @tracker, :project => @project, :priority => @enumeration)
      Journal.generate!(:issue => @issue)
      IssueStatus.generate!(:name => 'New')
      IssueStatus.generate!(:name => 'Closed')

      SourceUser.migrate
      SourceTracker.migrate
      SourceIssueStatus.migrate
      SourceEnumeration.migrate_issue_priorities
      SourceProject.migrate
      SourceVersion.migrate
      SourceIssueCategory.migrate
      SourceIssue.migrate
      SourceJournal.migrate

    end
    
    should_add_each_record_from_the_source_to_the_destination(JournalDetail, 2) { SourceJournalDetail.migrate }

    should "keep the journal associations" do
      SourceJournalDetail.migrate
      
      issue = Issue.find_by_subject("Can't print recipes")
      assert issue
      assert_equal 2, issue.journals.count

      journal = issue.journals.find_by_notes("Journal notes")
      assert journal
      assert_equal 2, journal.details.count
    end

    should "remap the property associations" do
      SourceJournalDetail.migrate
      
      issue = Issue.find_by_subject("Can't print recipes")
      assert issue

      journal = issue.journals.find_by_notes("Journal notes")
      assert journal

      detail = journal.details.find_by_prop_key('status_id')
      assert detail

      assert_equal IssueStatus.find_by_name('New').id, detail.old_value.to_i
      assert_equal IssueStatus.find_by_name('Assigned').id, detail.value.to_i
    end

  end
end
