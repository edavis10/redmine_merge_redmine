require File.dirname(__FILE__) + '/../test_helper'

class SourceWikiTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      SourceProject.migrate
      SourceWiki.migrate
      WikiPage.generate!(:title => "Test", :wiki => Wiki.last)
    end

    should_add_each_record_from_the_source_to_the_destination(WikiPage, 6) { SourceWikiPage.migrate }

    should "keep the wiki association" do
      SourceWikiPage.migrate

      wiki = Wiki.find_by_start_page('CookBook documentation')
      assert wiki
      assert_equal 5, wiki.pages.count
      assert wiki.pages.collect(&:title).include? 'CookBook_documentation'
      assert wiki.pages.collect(&:title).include? 'Another_page'
      assert wiki.pages.collect(&:title).include? 'Page_with_an_inline_image'
      assert wiki.pages.collect(&:title).include? 'Child_1'
      assert wiki.pages.collect(&:title).include? 'Child_2'
    end

    should "keep the parent_id association" do
      SourceWikiPage.migrate

      wiki = Wiki.find_by_start_page('CookBook documentation')
      assert wiki
      assert_equal 5, wiki.pages.count
      child_1 = wiki.pages.find_by_title('Child_1')
      assert_equal WikiPage.find_by_title('Another_page'), child_1.parent
      child_2 = wiki.pages.find_by_title('Child_2')
      assert_equal WikiPage.find_by_title('Another_page'), child_2.parent
    end

  end
end
