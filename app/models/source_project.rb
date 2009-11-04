class SourceProject < ActiveRecord::Base
  include SecondDatabase
  set_table_name :projects

  has_many :enabled_modules, :class_name => 'SourceEnabledModule', :foreign_key => 'project_id'
  has_and_belongs_to_many :trackers, :class_name => 'SourceTracker', :join_table => 'projects_trackers', :foreign_key => 'project_id', :association_foreign_key => 'tracker_id'
  
  def self.migrate
    all.each do |source_project|
      next if Project.find_by_name(source_project.name)
      next if Project.find_by_identifier(source_project.identifier)
      
      p = Project.new
      p.attributes = source_project.attributes
      p.status = source_project.status
      if source_project.enabled_modules
        p.enabled_module_names = source_project.enabled_modules.collect(&:name)
      end

      if source_project.trackers
        source_project.trackers.each do |source_tracker|
          merged_tracker = Tracker.find_by_name(source_tracker.name)
          p.trackers << merged_tracker if merged_tracker
        end
      end

      p.save!
    end
  end
end
