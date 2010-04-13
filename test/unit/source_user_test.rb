require File.dirname(__FILE__) + '/../test_helper'

class SourceUserTest < ActiveSupport::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      User.generate_with_protected!(:login => 'admin', :mail => 'admin@somenet.foo')
      User.generate_with_protected!(:login => 'jsmith', :mail => 'jsmith@somenet.foo')
    end
    
    should_add_each_record_from_the_source_to_the_destination(User, 4) { SourceUser.migrate }

    should "skip the anonymous user" do
      SourceUser.migrate
      
      assert_equal 1, AnonymousUser.count
    end
    
    should "skip users that already exist in the destination, based on email" do
      SourceUser.migrate

      assert_equal 1, User.count(:conditions => {:mail => 'admin@somenet.foo'})
      assert_equal 1, User.count(:conditions => {:mail => 'jsmith@somenet.foo'})
    end
    
    should "skip users that already exist in the destination, based on login" do
      SourceUser.migrate

      assert_equal 1, User.count(:conditions => {:login => 'admin'})
      assert_equal 1, User.count(:conditions => {:login => 'jsmith'})
    end
  end
end
