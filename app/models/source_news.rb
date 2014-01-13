class SourceNews < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}news#{table_name_suffix}"

  belongs_to :author, :class_name => 'SourceUser', :foreign_key => 'author_id'

  def self.migrate
    all.each do |source_news|
      News.create!(source_news.attributes) do |n|
        n.project = Project.find(RedmineMerge::Mapper.get_new_project_id(source_news.project_id))
        n.author = User.find_by_login(source_news.author.login)
      end
    end
  end
end
