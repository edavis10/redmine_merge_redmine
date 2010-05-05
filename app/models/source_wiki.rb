class SourceWiki < ActiveRecord::Base
  include SecondDatabase
  set_table_name :wikis

  def self.migrate
    all.each do |source_wiki|

      project = Project.find(RedmineMerge::Mapper.get_new_project_id(source_wiki.project_id))

      wiki = Wiki.create!(source_wiki.attributes) do |w|
        w.project = project
      end

      RedmineMerge::Mapper.add_wiki(source_wiki.id, wiki.id)

      # Need to remove any default wikis if they exist
      if project.wiki.start_page == 'Wiki' && wiki.start_page != 'Wiki'
        project.wiki.destroy
      end
    end
  end
end
