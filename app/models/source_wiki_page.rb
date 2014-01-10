class SourceWikiPage < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}wiki_pages#{table_name_suffix}"

  def self.migrate
    all(:order => 'parent_id ASC').each do |source_wiki_page|

      wiki_page = WikiPage.create!(source_wiki_page.attributes) do |wp|
        wp.wiki = Wiki.find(RedmineMerge::Mapper.get_new_wiki_id(source_wiki_page.wiki_id))
        wp.parent = WikiPage.find(RedmineMerge::Mapper.get_new_wiki_page_id(source_wiki_page.parent_id)) if source_wiki_page.parent_id
      end

      RedmineMerge::Mapper.add_wiki_page(source_wiki_page.id, wiki_page.id)
    end
  end
end
