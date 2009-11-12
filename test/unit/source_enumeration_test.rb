require File.dirname(__FILE__) + '/../test_helper'

class SourceEnumerationTest < Test::Unit::TestCase
  context "#migrate_issue_priorities" do
    setup do
      User.anonymous # preload
      Enumeration.generate!(:opt => "IPRI", :name => "Low")
    end
    
    should "add each Issue Priority from the source database to the destination database" do
      assert_difference("Enumeration.count", 4) do
        SourceEnumeration.migrate_issue_priorities
      end
    end

    should "skip Issue Priorities that already exist in the destination, based on name" do
      SourceEnumeration.migrate_issue_priorities

      assert_equal 1, Enumeration.count(:conditions => {:name => 'Low'})
    end
  end
end
