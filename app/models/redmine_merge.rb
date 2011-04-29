class RedmineMerge
  def self.migrate
    SourceUser.migrate
    SourceCustomField.migrate
    SourceTracker.migrate
    SourceIssueStatus.migrate
    SourceEnumeration.migrate_issue_priorities
    SourceEnumeration.migrate_time_entry_activities
    SourceEnumeration.migrate_document_categories

    # Project-specific data
    SourceProject.migrate
    SourceVersion.migrate
    SourceNews.migrate
    SourceIssueCategory.migrate
    SourceIssue.migrate
    SourceIssueRelation.migrate
    SourceJournal.migrate
    SourceJournalDetail.migrate
    SourceTimeEntry.migrate
    SourceDocument.migrate
    SourceWiki.migrate
    SourceWikiPage.migrate
    SourceWikiContent.migrate
    SourceAttachment.migrate
  end

  class Mapper
    Projects = {}
    Issues = {}
    Journals = {}
    Wikis = {}
    WikiPages = {}
    Documents = {}
    Versions = {}
    Users = {}

    def self.add_user(source_id, new_id)
      Users[source_id] = new_id
    end

    def self.get_new_user_id(source_id)
      Users[source_id]
    end

    def self.add_project(source_id, new_id)
      Projects[source_id] = new_id
    end

    def self.get_new_project_id(source_id)
      Projects[source_id]
    end

    def self.add_issue(source_id, new_id)
      Issues[source_id] = new_id
    end

    def self.get_new_issue_id(source_id)
      Issues[source_id]
    end

    def self.add_journal(source_id, new_id)
      Journals[source_id] = new_id
    end

    def self.get_new_journal_id(source_id)
      Journals[source_id]
    end

    def self.add_wiki(source_id, new_id)
      Wikis[source_id] = new_id
    end

    def self.get_new_wiki_id(source_id)
      Wikis[source_id]
    end

    def self.add_wiki_page(source_id, new_id)
      WikiPages[source_id] = new_id
    end

    def self.get_new_wiki_page_id(source_id)
      WikiPages[source_id]
    end

    def self.add_document(source_id, new_id)
      Documents[source_id] = new_id
    end

    def self.get_new_document_id(source_id)
      Documents[source_id]
    end

    def self.add_version(source_id, new_id)
      Versions[source_id] = new_id
    end

    def self.get_new_version_id(source_id)
      Versions[source_id]
    end

    def self.find_id_by_property(target_klass, source_id)
      # Similar to issues_helper.rb#show_detail
      source_id = source_id.to_i

      case target_klass.to_s
      when 'Project'
        return Mapper.get_new_journal_id(source_id)
      when 'IssueStatus'
        target = find_target_record_from_source(SourceIssueStatus, IssueStatus, :name, source_id)
        return target.id if target
        return nil
      when 'Tracker'
        target = find_target_record_from_source(SourceTracker, Tracker, :name, source_id)
        return target.id if target
        return nil
      when 'User'
        target = find_target_record_from_source(SourceUser, User, :login, source_id)
        return target.id if target
        return nil
      when 'Enumeration'
        target = find_target_record_from_source(SourceEnumeration, Enumeration, :name, source_id)
        return target.id if target
        return nil
      when 'IssueCategory'
        source = SourceIssueCategory.find_by_id(source_id)
        return nil unless source
        target = IssueCategory.find_by_name_and_project_id(source.name, RedmineMerge::Mapper.get_new_project_id(source.project_id))
        return target.id if target
        return nil
      when 'Version'
        source = SourceVersion.find_by_id(source_id)
        return nil unless source
        target = Version.find_by_name_and_project_id(source.name, RedmineMerge::Mapper.get_new_project_id(source.project_id))
        return target.id if target
        return nil
      end
      
    end

    private

    # Utility method to dynamically find the target records
    def self.find_target_record_from_source(source_klass, target_klass, field, source_id)
      source = source_klass.find_by_id(source_id)
      field = field.to_sym
      if source
        return target_klass.find(:first, :conditions => {field => source.read_attribute(field) })
      else
        return nil
      end
    end
  end
end
