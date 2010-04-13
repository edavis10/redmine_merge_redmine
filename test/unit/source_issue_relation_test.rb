require File.dirname(__FILE__) + '/../test_helper'

class SourceIssueRelationTest < ActiveSupport::TestCase
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
    
    should_add_each_record_from_the_source_to_the_destination(IssueRelation, 3) { SourceIssueRelation.migrate }

    should "keep the issue_from and issue_to associations" do
      SourceIssueRelation.migrate
      
      issue = Issue.find_by_subject("Can't print recipes")
      assert issue
      assert_equal 2, issue.relations.count
    end

  end
end
