require File.dirname(__FILE__) + '/../test_helper'

class SourceVersionTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      Version.generate!(:name => '0.1')
      SourceProject.migrate
    end
    
    should "add each Version from the source database to the destination database" do
      assert_difference("Version.count", 2) do
        SourceVersion.migrate
      end
    end

    should "skip Versions that already exist in the destination, based on name" do
      SourceVersion.migrate

      assert_equal 1, Version.count(:conditions => {:name => '0.1'})
    end

    should "associate Versions with the newly merged projects" do
      SourceVersion.migrate

      project = Project.find_by_name('eCookbook')
      assert_equal 2, project.versions.length # 3rd wasn't migrate due to name conflict
      assert project.versions.collect(&:name).include? '1.0'
      assert project.versions.collect(&:name).include? '2.0'
    end
  end
end
