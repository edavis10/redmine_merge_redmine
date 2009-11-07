class RedmineMerge
  def self.migrate
    SourceUser.migrate
    SourceCustomField.migrate
    SourceTracker.migrate
    SourceIssueStatus.migrate

    # Project-specific data
    SourceProject.migrate
    SourceVersion.migrate
    SourceNews.migrate
    SourceIssueCategory.migrate
  end

  class Mapper
    Projects = {}

    def self.add_project(source_id, new_id)
      Projects[source_id] = new_id
    end

    def self.get_new_project_id(source_id)
      Projects[source_id]
    end
  end
end
