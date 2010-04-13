require File.dirname(__FILE__) + '/../test_helper'

class SourceTimeEntryTest < ActiveSupport::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload

      # Make sure objects are associating correctly and not that they
      # just happen to match ids.
      @project = Project.generate!
      @tracker = Tracker.generate!
      @project.trackers << @tracker
      @enumeration = Enumeration.generate!(:opt => 'IPRI')
      Issue.generate!(:tracker => @tracker, :project => @project, :priority => @enumeration)
      Enumeration.generate!(:opt => "ACTI", :name => "Design")

      SourceUser.migrate
      SourceTracker.migrate
      SourceIssueStatus.migrate
      SourceEnumeration.migrate_issue_priorities
      SourceEnumeration.migrate_time_entry_activities
      SourceProject.migrate
      SourceVersion.migrate
      SourceIssueCategory.migrate
      SourceIssue.migrate

    end
    
    should_add_each_record_from_the_source_to_the_destination(TimeEntry, 4) { SourceTimeEntry.migrate }

    should "keep the issue associations" do
      SourceTimeEntry.migrate
      
      issue = Issue.find_by_subject("Can't print recipes")
      assert issue
      assert_equal 2, issue.time_entries.count
      assert issue.time_entries.collect(&:comments).include? "My hours"
      assert issue.time_entries.collect(&:hours).include? 150.0
    end

    should "keep the project association" do
      SourceTimeEntry.migrate

      time_entry = TimeEntry.find_by_comments("Time spent on a subproject")
      assert time_entry
      assert_equal Project.find_by_name('eCookbook Subproject 1'), time_entry.project
    end

    should "keep the user association" do
      SourceTimeEntry.migrate

      time_entry = TimeEntry.find_by_comments("Time spent on a subproject")
      assert time_entry
      assert_equal User.find_by_login('admin'), time_entry.user
    end

    should "keep the activity association" do
      SourceTimeEntry.migrate

      time_entry = TimeEntry.find_by_comments("My hours")
      assert time_entry
      assert_equal Enumeration.find_by_name('Design'), time_entry.activity
    end
  end
end
