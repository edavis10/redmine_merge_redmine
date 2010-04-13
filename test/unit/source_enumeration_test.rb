require File.dirname(__FILE__) + '/../test_helper'

class SourceEnumerationTest < ActiveSupport::TestCase
  context "#migrate_issue_priorities" do
    setup do
      User.anonymous # preload
      IssuePriority.generate!(:name => 'Low')
    end

    should_add_each_record_from_the_source_to_the_destination(IssuePriority, 4) { SourceEnumeration.migrate_issue_priorities }

    should "skip Issue Priorities that already exist in the destination, based on name" do
      SourceEnumeration.migrate_issue_priorities

      assert_equal 1, IssuePriority.count(:conditions => {:name => 'Low'})
    end
  end

  context "#migrate_time_entry_activities" do
    setup do
      User.anonymous # preload
      TimeEntryActivity.generate!(:name => "Design")
    end

    should_add_each_record_from_the_source_to_the_destination(TimeEntryActivity, 2) { SourceEnumeration.migrate_time_entry_activities }

    should "skip Activities that already exist in the destination, based on name" do
      SourceEnumeration.migrate_time_entry_activities

      assert_equal 1, TimeEntryActivity.count(:conditions => {:name => 'Design'})
    end
  end

  context "#migrate_document_categories" do
    setup do
      User.anonymous # preload
      DocumentCategory.generate!(:name => "Technical documentation")
    end

    should_add_each_record_from_the_source_to_the_destination(DocumentCategory, 2) { SourceEnumeration.migrate_document_categories }

    should "skip Document Categories that already exist in the destination, based on name" do
      SourceEnumeration.migrate_document_categories

      assert_equal 1, DocumentCategory.count(:conditions => {:name => 'Technical documentation'})
    end
  end
end
