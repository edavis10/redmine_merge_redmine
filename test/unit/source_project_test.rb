require File.dirname(__FILE__) + '/../test_helper'

class SourceProjectTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      User.generate_with_protected!(:login => 'admin', :mail => 'admin@somenet.foo')
      User.generate_with_protected!(:login => 'jsmith', :mail => 'jsmith@somenet.foo')

      Project.generate!(:name => 'eCookbook')
      Project.generate!(:identifier => 'onlinestore')
    end
    
    should "add each project from the source database to the destination database" do
      # Skip the two projects above
      assert_difference("Project.count", 4) do
        SourceProject.migrate
      end
    end

    should "skip projects that already exist in the destination, based on name" do
      SourceProject.migrate

      assert_equal 1, Project.count(:conditions => {:name => 'eCookbook'})
    end
    
    should "skip projects that already exist in the destination, based on identifier" do
      SourceProject.migrate

      assert_equal 1, Project.count(:conditions => {:identifier => 'onlinestore'})
    end

    should "enable the modules for each project" do
      SourceProject.migrate

      project = Project.find_by_identifier('subproject1')

      assert project
      assert_equal 4, project.enabled_modules.length
      assert project.enabled_modules.collect(&:name).include?('repository')
      assert project.enabled_modules.collect(&:name).include?('wiki')
      assert project.enabled_modules.collect(&:name).include?('time_tracking')
      assert project.enabled_modules.collect(&:name).include?('issue_tracking')
    end
  end
end
