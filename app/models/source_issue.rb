class SourceIssue < ActiveRecord::Base
  include SecondDatabase
  set_table_name :issues

  belongs_to :author, :class_name => 'SourceUser', :foreign_key => 'author_id'
  belongs_to :assigned_to, :class_name => 'SourceUser', :foreign_key => 'assigned_to_id'
  belongs_to :status, :class_name => 'SourceIssueStatus', :foreign_key => 'status_id'
  belongs_to :tracker, :class_name => 'SourceTracker', :foreign_key => 'tracker_id'
  belongs_to :project, :class_name => 'SourceProject', :foreign_key => 'project_id'
  belongs_to :priority, :class_name => 'SourceEnumeration', :foreign_key => 'priority_id'
  belongs_to :category, :class_name => 'SourceIssueCategory', :foreign_key => 'category_id'
  
  def self.migrate
    all.each do |source_issue|

      i = Issue.new
      i.attributes = source_issue.attributes

      i.project = Project.find_by_name(source_issue.project.name)
      i.author = User.find_by_login(source_issue.author.login)
      i.assigned_to = User.find_by_login(source_issue.assigned_to.login) if source_issue.assigned_to
      i.status = IssueStatus.find_by_name(source_issue.status.name)
      i.tracker = Tracker.find_by_name(source_issue.tracker.name)
      i.priority = IssuePriority.find_by_name(source_issue.priority.name)
      i.category = IssueCategory.find_by_name(source_issue.category.name) if source_issue.category

      i.save!
      RedmineMerge::Mapper.add_issue(source_issue.id, i.id)
    end
  end
end
