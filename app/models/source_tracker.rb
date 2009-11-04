class SourceTracker < ActiveRecord::Base
  include SecondDatabase
  set_table_name :trackers

  def self.migrate
    all.each do |source_tracker|
      next if Tracker.find_by_name(source_tracker.name)

      t = Tracker.new
      t.attributes = source_tracker.attributes
      t.save!
    end
  end
end
