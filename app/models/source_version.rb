class SourceVersion < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}versions#{table_name_suffix}"

  def self.migrate
    all.each do |source_version|
      version = Version.create!(source_version.attributes) do |v|
        v.project = Project.find(RedmineMerge::Mapper.get_new_project_id(source_version.project_id))
      end

      RedmineMerge::Mapper.add_version(source_version.id, version.id)
    end
  end
end
