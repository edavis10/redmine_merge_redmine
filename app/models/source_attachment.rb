class SourceAttachment < ActiveRecord::Base
  include SecondDatabase
  set_table_name :attachments

  belongs_to :author, :class_name => 'SourceUser', :foreign_key => 'author_id'

  def self.migrate
    all.each do |source_attachment|

      a = Attachment.new
      a.attributes = source_attachment.attributes
      a.author = User.find_by_login(source_attachment.author.login)
      a.container = case source_attachment.container_type
                    when "Issue"
                      Issue.find RedmineMerge::Mapper.get_new_issue_id(source_attachment.container_id)
                    when "Document"
                      Document.find RedmineMerge::Mapper.get_new_document_id(source_attachment.container_id)
                    when "WikiPage"
                      WikiPage.find RedmineMerge::Mapper.get_new_wiki_page_id(source_attachment.container_id)
                    when "Project"
                      Project.find RedmineMerge::Mapper.get_new_project_id(source_attachment.container_id)
                    when "Version"
                      Version.find RedmineMerge::Mapper.get_new_version_id(source_attachment.container_id)
                    end

      a.save!
    end
  end
end
