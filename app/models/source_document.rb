class SourceDocument < ActiveRecord::Base
  include SecondDatabase
  set_table_name :documents

  belongs_to :category, :class_name => 'SourceEnumeration', :foreign_key => 'category_id'

  def self.migrate
    all.each do |source_document|

      document = Document.create!(source_document.attributes) do |d|
        d.project = Project.find(RedmineMerge::Mapper.get_new_project_id(source_document.project_id))
        d.category = DocumentCategory.find_by_name(source_document.category.name)
      end
      
      RedmineMerge::Mapper.add_document(source_document.id, document.id)
    end
  end
end
