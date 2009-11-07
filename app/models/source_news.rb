class SourceNews < ActiveRecord::Base
  include SecondDatabase
  set_table_name :news

  def self.migrate
    all.each do |source_news|
      next if News.find_by_title(source_news.title)

      n = News.new
      n.attributes = source_news.attributes
      n.project = Project.find(RedmineMerge::Mapper.get_new_project_id(source_news.project_id))
      n.save!
    end
  end
end
