require File.dirname(__FILE__) + '/../test_helper'

class SourceCustomFieldTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      CustomField.generate!(:name => 'Database', :field_format => 'string')
    end

    should_add_each_record_from_the_source_to_the_destination(CustomField, 5) { SourceCustomField.migrate }

    should "skip Custom Fields that already exist in the destination, based on name" do
      SourceTracker.migrate

      assert_equal 1, CustomField.count(:conditions => {:name => 'Database'})
    end
  end
end
