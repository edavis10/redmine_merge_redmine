require File.dirname(__FILE__) + '/../test_helper'

class SourceNewsTest < ActiveSupport::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      News.generate!(:title => "100,000 downloads for eCookbook", :description => 'Yay')
      SourceUser.migrate
      SourceProject.migrate
    end

    should_add_each_record_from_the_source_to_the_destination(News, 2) { SourceNews.migrate }

    should "allow duplicate News items per project" do
      SourceNews.migrate

      assert_equal 2, News.count(:conditions => {:title => '100,000 downloads for eCookbook'})
    end

    should "associate News with the newly merged projects" do
      SourceNews.migrate

      project = Project.find_by_name('eCookbook')
      assert_equal 2, project.news.length
      assert project.news.collect(&:title).include? 'eCookbook first release !'
    end

    should "keep the author association" do
      SourceNews.migrate

      news = News.find_by_title('eCookbook first release !')
      assert news
      assert_equal "jsmith", news.author.login
    end

  end
end
