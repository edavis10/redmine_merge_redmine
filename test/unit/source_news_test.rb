require File.dirname(__FILE__) + '/../test_helper'

class SourceNewsTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      News.generate!(:title => "100,000 downloads for eCookbook", :description => 'Yay')
      SourceProject.migrate
    end
    
    should "add each News from the source database to the destination database" do
      assert_difference("News.count", 1) do
        SourceNews.migrate
      end
    end

    should "skip News that already exist in the destination, based on name" do
      SourceNews.migrate

      assert_equal 1, News.count(:conditions => {:title => '100,000 downloads for eCookbook'})
    end

    should "associate News with the newly merged projects" do
      SourceNews.migrate

      project = Project.find_by_name('eCookbook')
      assert_equal 1, project.news.length # 2nd wasn't migrate due to name conflict
      assert project.news.collect(&:title).include? 'eCookbook first release !'
    end
  end
end
