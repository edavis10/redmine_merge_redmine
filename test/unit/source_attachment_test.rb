require File.dirname(__FILE__) + '/../test_helper'

class SourceAttachmentTest < Test::Unit::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      SourceUser.migrate
      SourceTracker.migrate
      SourceIssueStatus.migrate
      SourceEnumeration.migrate_issue_priorities
      SourceEnumeration.migrate_document_categories
      SourceProject.migrate
      SourceVersion.migrate
      SourceNews.migrate
      SourceIssueCategory.migrate
      SourceIssue.migrate
      SourceDocument.migrate
      SourceWiki.migrate
      SourceWikiPage.migrate
    end

    should_add_each_record_from_the_source_to_the_destination(Attachment, 9) { SourceAttachment.migrate }

    should "keep the container association" do
      SourceAttachment.migrate

      attachment = Attachment.find_by_disk_filename('060719210727_logo.gif')
      assert attachment
      assert_equal "WikiPage", attachment.container_type
      assert_equal "Page_with_an_inline_image", attachment.container.title
    end

    should "keep the author association" do
      SourceAttachment.migrate

      attachment = Attachment.find_by_disk_filename('060719210727_logo.gif')
      assert attachment
      assert_equal User.find_by_login('jsmith'), attachment.author

    end
  end
end
