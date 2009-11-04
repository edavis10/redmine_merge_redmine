require File.dirname(__FILE__) + '/../test_helper'

class SourceTrackerTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      User.generate_with_protected!(:login => 'admin', :mail => 'admin@somenet.foo')
      User.generate_with_protected!(:login => 'jsmith', :mail => 'jsmith@somenet.foo')

      Tracker.generate!(:name => 'Bug')
    end
    
    should "add each tracker from the source database to the destination database" do
      assert_difference("Tracker.count", 2) do
        SourceTracker.migrate
      end
    end

    should "skip trackers that already exist in the destination, based on name" do
      SourceTracker.migrate

      assert_equal 1, Tracker.count(:conditions => {:name => 'Bug'})
    end
  end
end
