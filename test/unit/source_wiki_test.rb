require File.dirname(__FILE__) + '/../test_helper'

class SourceWikiTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      SourceProject.migrate
    end

    # One record is replaced, one is added. Net +1
    should_add_each_record_from_the_source_to_the_destination(Wiki, 1) { SourceWiki.migrate }

    should "keep the project association" do
      SourceWiki.migrate

      project = Project.find_by_name('eCookbook')
      assert project
      assert project.wiki
      assert_equal "CookBook documentation", project.wiki.start_page
    end

  end
end
