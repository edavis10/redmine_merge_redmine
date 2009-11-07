require File.dirname(__FILE__) + '/../test_helper'

class SourceIssueCategoryTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      IssueCategory.generate!(:name => "Printing")
      SourceProject.migrate
    end
    
    should "add each IssueCategory from the source database to the destination database" do
      assert_difference("IssueCategory.count", 4) do
        SourceIssueCategory.migrate
      end
    end

    should "skip Issue Categories that already exist in the destination, based on name and project" do
      SourceIssueCategory.migrate

      assert_equal 3, IssueCategory.count(:conditions => {:name => 'Printing'})
      printings = IssueCategory.all(:conditions => {:name => 'Printing'}).collect(&:project_id)

      assert_equal 3, printings.to_set.length
    end

    should "associate Issue Categories with the newly merged projects" do
      SourceIssueCategory.migrate

      project = Project.find_by_name('eCookbook')
      assert_equal 2, project.issue_categories.length
      assert project.issue_categories.collect(&:name).include? 'Printing'
      assert project.issue_categories.collect(&:name).include? 'Recipes'
    end
  end
end
