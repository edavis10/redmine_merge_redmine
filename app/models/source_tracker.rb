class SourceTracker < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}trackers#{table_name_suffix}"

  has_and_belongs_to_many :projects, :class_name => 'SourceProject', :join_table => 'projects_trackers', :foreign_key => 'tracker_id', :association_foreign_key => 'project_id'

  def self.migrate
    all.each do |source_tracker|
      next if Tracker.find_by_name(source_tracker.name)

      Tracker.create!(source_tracker.attributes)
    end
  end
end
