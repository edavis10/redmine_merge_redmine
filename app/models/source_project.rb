class SourceProject < ActiveRecord::Base
  include SecondDatabase
  set_table_name :projects

  has_many :enabled_modules, :class_name => 'SourceEnabledModule', :foreign_key => 'project_id'
  
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
      p.save!
    end
  end
end
