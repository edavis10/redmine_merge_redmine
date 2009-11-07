require File.dirname(__FILE__) + '/../test_helper'

class SourceIssueStatusTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      IssueStatus.generate!(:name => 'New')
      IssueStatus.generate!(:name => 'Closed')
    end
    
    should "add each Issue Status from the source database to the destination database" do
      assert_difference("IssueStatus.count", 4) do
        SourceIssueStatus.migrate
      end
    end

    should "skip Issue Status that already exist in the destination, based on name" do
      SourceIssueStatus.migrate

      assert_equal 1, IssueStatus.count(:conditions => {:name => 'New'})
    end
  end
end
