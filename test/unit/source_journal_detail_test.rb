require File.dirname(__FILE__) + '/../test_helper'

class SourceJournalDetailTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload

      # Make sure Journals are associating correctly and not that they
      # just happen to match ids.
      @project = Project.generate!
      @tracker = Tracker.generate!
      @project.trackers << @tracker
      @enumeration = Enumeration.generate!(:opt => 'IPRI')
      @issue = Issue.generate!(:tracker => @tracker, :project => @project, :priority => @enumeration)
      Journal.generate!(:issue => @issue)

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
      journal.details.each do |detail|
        assert detail.prop_key == "status_id" || detail.prop_key == "done_ratio"
        assert detail.old_value == '1' || detail.old_value == '40'
        assert detail.value = '2' || detail.value == '30'
      end
    end

  end
end
