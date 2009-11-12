require File.dirname(__FILE__) + '/../test_helper'

class SourceIssueCategoryTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      IssueCategory.generate!(:name => "Printing")
      SourceProject.migrate
    end
    
    should_add_each_record_from_the_source_to_the_destination(IssueCategory, 4) { SourceIssueCategory.migrate }

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
