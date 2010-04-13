require File.dirname(__FILE__) + '/../test_helper'

class SourceDocumentTest < ActiveSupport::TestCase
  context "#migrate" do
    setup do
      User.anonymous # preload
      DocumentCategory.generate!(:name => "Technical documentation")
      SourceEnumeration.migrate_document_categories
      SourceProject.migrate
    end
    
    should_add_each_record_from_the_source_to_the_destination(Document, 1) { SourceDocument.migrate }

    should "keep the project association" do
      SourceDocument.migrate

      document = Document.find_by_title('Test document')
      assert document
      assert_equal Project.find_by_name('eCookbook'), document.project
    end

    should "keep the Document Category association" do
      SourceDocument.migrate

      document = Document.find_by_title('Test document')
      assert document
      assert_equal DocumentCategory.find_by_name('Uncategorized'), document.category
    end
  end
end
