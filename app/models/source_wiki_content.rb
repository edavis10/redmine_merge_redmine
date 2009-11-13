class SourceWikiContent < ActiveRecord::Base
  include SecondDatabase
  set_table_name :wiki_contents

  belongs_to :author, :class_name => 'SourceUser', :foreign_key => 'author_id'

  def self.migrate
    all.each do |source_wiki_content|

      wc = WikiContent.new
      wc.attributes = source_wiki_content.attributes
      wc.page = WikiPage.find(RedmineMerge::Mapper.get_new_wiki_page_id(source_wiki_content.page_id))
      wc.author = User.find_by_login(source_wiki_content.author.login)
      wc.save!
    end
  end
end
