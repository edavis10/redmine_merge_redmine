class SourceWikiPage < ActiveRecord::Base
  include SecondDatabase
  set_table_name :wiki_pages

  def self.migrate
    all(:order => 'parent_id ASC').each do |source_wiki_page|

      wp = WikiPage.new
      wp.attributes = source_wiki_page.attributes
      wp.wiki = Wiki.find(RedmineMerge::Mapper.get_new_wiki_id(source_wiki_page.wiki_id))
      wp.parent = WikiPage.find(RedmineMerge::Mapper.get_new_wiki_page_id(source_wiki_page.parent_id)) if source_wiki_page.parent_id
      wp.save!

      RedmineMerge::Mapper.add_wiki_page(source_wiki_page.id, wp.id)
    end
  end
end
