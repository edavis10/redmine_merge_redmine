class SourceNews < ActiveRecord::Base
  include SecondDatabase
  set_table_name :news

  belongs_to :author, :class_name => 'SourceUser', :foreign_key => 'author_id'

  def self.migrate
    all.each do |source_news|
      News.create!(source_news.attributes) do |n|
        n.project = Project.find(RedmineMerge::Mapper.get_new_project_id(source_news.project_id))
        n.author = User.find(RedmineMerge::Mapper.get_new_user_id(source_news.author.id))
      end
    end
  end
end
