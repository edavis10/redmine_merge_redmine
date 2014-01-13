class SourceIssueCategory < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}issue_categories#{table_name_suffix}"

  def self.migrate
    all.each do |source_issue_category|
      next if IssueCategory.find_by_name_and_project_id(source_issue_category.name, source_issue_category.project_id)

      IssueCategory.create!(source_issue_category.attributes) do |ic|
        ic.project = Project.find(RedmineMerge::Mapper.get_new_project_id(source_issue_category.project_id))
      end
    end
  end
end
