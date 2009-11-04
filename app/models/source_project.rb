class SourceProject < ActiveRecord::Base
  include SecondDatabase
  set_table_name :projects

  def self.migrate
    all.each do |source_project|
      next if Project.find_by_name(source_project.name)
      next if Project.find_by_identifier(source_project.identifier)
      
      p = Project.new
      p.attributes = source_project.attributes
      p.status = source_project.status
      p.save!
    end
  end
end
