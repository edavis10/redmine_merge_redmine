class SourceAttachment < ActiveRecord::Base
  include SecondDatabase
  set_table_name :attachments

  belongs_to :author, :class_name => 'SourceUser', :foreign_key => 'author_id'

  def self.migrate
    all.each do |source_attachment|
      next if Attachment.find(:first, :conditions => {:filename => source_attachment.filename,
        :disk_filename => source_attachment.disk_filename,
        :digest => source_attachment.digest,
        :container_type => source_attachment.container_type})

      Attachment.create!(source_attachment.attributes) do |a|
        a.author = User.find_by_mail(source_attachment.author.mail)
        a.author = User.find_by_login(source_attachment.author.login) if a.author.blank?
        a.container = case source_attachment.container_type
                      when "Issue"
                        id = RedmineMerge::Mapper.get_new_issue_id(source_attachment.container_id)
                        Issue.find id if id
                      when "Document"
                        id = RedmineMerge::Mapper.get_new_document_id(source_attachment.container_id)
                        Document.find id if id
                      when "WikiPage"
                        id = RedmineMerge::Mapper.get_new_wiki_page_id(source_attachment.container_id)
                        WikiPage.find id if id
                      when "Project"
                        id = RedmineMerge::Mapper.get_new_project_id(source_attachment.container_id)
                        Project.find id if id
                      when "Version"
                        id = RedmineMerge::Mapper.get_new_version_id(source_attachment.container_id)
                        Version.find id if id
                      end

      end
    end
  end
end
