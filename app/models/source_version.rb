class SourceVersion < ActiveRecord::Base
  include SecondDatabase
  set_table_name :versions

  def self.migrate
    all.each do |source_version|
      v = Version.new
      v.attributes = source_version.attributes
      v.project = Project.find(RedmineMerge::Mapper.get_new_project_id(source_version.project_id))
      v.save!

      RedmineMerge::Mapper.add_version(source_version.id, v.id)
    end
  end
end
