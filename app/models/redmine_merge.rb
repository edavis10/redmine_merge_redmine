class RedmineMerge
  def self.migrate
    SourceUser.migrate
    SourceCustomField.migrate
    SourceTracker.migrate
    SourceProject.migrate
  end
end
