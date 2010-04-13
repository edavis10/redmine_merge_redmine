require File.dirname(__FILE__) + '/../test_helper'

class SourceVersionTest < ActiveSupport::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      Version.generate!(:name => '0.1')
      SourceProject.migrate
    end
    
    should_add_each_record_from_the_source_to_the_destination(Version, 3) { SourceVersion.migrate }

    should "associate Versions with the newly merged projects" do
      SourceVersion.migrate

      project = Project.find_by_name('eCookbook')
      assert_equal 3, project.versions.length
      assert project.versions.collect(&:name).include? '0.1'
      assert project.versions.collect(&:name).include? '1.0'
      assert project.versions.collect(&:name).include? '2.0'
    end
  end
end
