require File.dirname(__FILE__) + '/../test_helper'

class SourceDatabaseTest < ActiveSupport::TestCase
  context "connecting to the testing source database" do
    should "have users" do
      assert_equal 7, SourceUser.count
    end
  end
end
