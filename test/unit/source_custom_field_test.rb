require File.dirname(__FILE__) + '/../test_helper'

class SourceCustomFieldTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      CustomField.generate!(:name => 'Database', :field_format => 'string')
    end
    
    should "add each Custom Field from the source database to the destination database" do
      assert_difference("CustomField.count", 5) do
        SourceCustomField.migrate
      end
    end

    should "skip Custom Fields that already exist in the destination, based on name" do
      SourceTracker.migrate

      assert_equal 1, CustomField.count(:conditions => {:name => 'Database'})
    end
  end
end
