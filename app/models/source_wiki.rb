class SourceWiki < ActiveRecord::Base
  include SecondDatabase
  set_table_name :wikis

  def self.migrate
    all.each do |source_wiki|

      w = Wiki.new
      w.attributes = source_wiki.attributes
      project = Project.find(RedmineMerge::Mapper.get_new_project_id(source_wiki.project_id))
      w.project = project
      w.save!

      RedmineMerge::Mapper.add_wiki(source_wiki.id, w.id)

      # Need to remove any default wikis if they exist
      if project.wiki.start_page == 'Wiki' && w.start_page != 'Wiki'
        project.wiki.destroy
      end
    end
  end
end
