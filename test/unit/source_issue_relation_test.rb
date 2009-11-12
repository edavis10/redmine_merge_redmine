require File.dirname(__FILE__) + '/../test_helper'

class SourceIssueRelationTest < Test::Unit::TestCase
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
      SourceIssue.migrate
    end
    
    should "add each Issue Relation from the source database to the destination database" do
      assert_difference("IssueRelation.count", 3) do
        SourceIssueRelation.migrate
      end
    end

    should "keep the issue_from and issue_to associations" do
      SourceIssueRelation.migrate
      
      issue = Issue.find_by_subject("Can't print recipes")
      assert issue
      assert_equal 2, issue.relations.count
    end

  end
end
