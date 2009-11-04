require File.dirname(__FILE__) + '/../test_helper'

class SourceUserTest < Test::Unit::TestCase
  context "#migrate" do
    should "add each user from the source database to the destination database"
    should "skip users that already exist in the destination, based on email"
    should "skip users that already exist in the destination, based on login"
  end
end
