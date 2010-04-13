require File.dirname(__FILE__) + '/../test_helper'

class SourceWikiContentTest < ActiveSupport::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      SourceUser.migrate
      SourceProject.migrate
      SourceWiki.migrate
      WikiPage.generate!(:title => "Test", :wiki => Wiki.last)
      SourceWikiPage.migrate
    end

    should_add_each_record_from_the_source_to_the_destination(WikiContent, 6) { SourceWikiContent.migrate }

    should "keep the Wiki Page association" do
      SourceWikiContent.migrate

      wiki_page = WikiPage.find_by_title('CookBook_documentation')
      assert wiki_page
      assert wiki_page.content
      assert_equal "Gzip compression activated", wiki_page.content.comments
    end

    should "keep the author association" do
      SourceWikiContent.migrate

      wiki_page = WikiPage.find_by_title('CookBook_documentation')
      assert wiki_page
      assert wiki_page.content
      assert_equal User.find_by_login('admin'), wiki_page.content.author

    end
  end
end
