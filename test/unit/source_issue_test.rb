require File.dirname(__FILE__) + '/../test_helper'

class SourceIssueTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      SourceUser.migrate
      SourceTracker.migrate
      SourceIssueStatus.migrate
      SourceEnumeration.migrate_issue_priorities
      SourceProject.migrate
      SourceVersion.migrate
      SourceIssueCategory.migrate
    end
    
    should "add each Issue from the source database to the destination database" do
      assert_difference("Issue.count", 8) do
        SourceIssue.migrate
      end
    end

    should "keep the tracker association" do
      SourceIssue.migrate

      issue = Issue.find_by_subject("Closed issue")
      assert issue
      assert_equal "Bug", issue.tracker.name
    end

    should "keep the project association" do
      SourceIssue.migrate

      issue = Issue.find_by_subject("Closed issue")
      assert issue
      assert_equal "eCookbook", issue.project.name
    end

    should "keep the author association" do
      SourceIssue.migrate

      issue = Issue.find_by_subject("Closed issue")
      assert issue
      assert_equal "jsmith", issue.author.login
    end
    
    should "keep the status association" do
      SourceIssue.migrate

      issue = Issue.find_by_subject("Closed issue")
      assert issue
      assert_equal "Closed", issue.status.name
    end
    
    should "keep the assigned_to association" do
      SourceIssue.migrate

      issue = Issue.find_by_subject("Add ingredients categories")
      assert issue
      assert_equal "dlopper", issue.assigned_to.login
    end

    should "keep the fixed_version association" do
      SourceIssue.migrate

      issue = Issue.find_by_subject("Add ingredients categories")
      assert issue
      assert_equal "Stable release", issue.fixed_version.description
    end

    should "keep the priority association" do
      SourceIssue.migrate

      issue = Issue.find_by_subject("Can't print recipes")
      assert issue
      assert_equal "Low", issue.priority.name
    end

    should "keep the category association" do
      SourceIssue.migrate

      issue = Issue.find_by_subject("Can't print recipes")
      assert issue
      assert_equal "Printing", issue.category.name
    end

  end
end
