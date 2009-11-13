require File.dirname(__FILE__) + '/../test_helper'

class SourceEnumerationTest < Test::Unit::TestCase
  context "#migrate_issue_priorities" do
    setup do
      User.anonymous # preload
      Enumeration.generate!(:opt => "IPRI", :name => "Low")
    end

    should_add_each_record_from_the_source_to_the_destination(Enumeration, 4) { SourceEnumeration.migrate_issue_priorities }

    should "skip Issue Priorities that already exist in the destination, based on name" do
      SourceEnumeration.migrate_issue_priorities

      assert_equal 1, Enumeration.count(:conditions => {:name => 'Low'})
    end
  end

  context "#migrate_time_entry_activities" do
    setup do
      User.anonymous # preload
      Enumeration.generate!(:opt => "ACTI", :name => "Design")
    end

    should_add_each_record_from_the_source_to_the_destination(Enumeration, 2) { SourceEnumeration.migrate_time_entry_activities }

    should "skip Activities that already exist in the destination, based on name" do
      SourceEnumeration.migrate_time_entry_activities

      assert_equal 1, Enumeration.count(:conditions => {:name => 'Design'})
    end
  end
end
