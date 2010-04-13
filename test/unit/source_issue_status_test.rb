require File.dirname(__FILE__) + '/../test_helper'

class SourceIssueStatusTest < ActiveSupport::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      IssueStatus.generate!(:name => 'New')
      IssueStatus.generate!(:name => 'Closed')
    end
    
    should_add_each_record_from_the_source_to_the_destination(IssueStatus, 4) { SourceIssueStatus.migrate }

    should "skip Issue Status that already exist in the destination, based on name" do
      SourceIssueStatus.migrate

      assert_equal 1, IssueStatus.count(:conditions => {:name => 'New'})
    end
  end
end
