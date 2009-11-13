namespace :redmine do
  desc 'Merge two Redmine databases'
  task :merge_redmine => :environment do
    puts "== Pre merge"
    [User, CustomField, Tracker, IssueStatus, Enumeration,
     Project, Version, News, IssueCategory, Issue, IssueRelation, Journal, JournalDetail].each do |model|
      puts "#{model}: #{model.count}"
    end
    
    RedmineMerge.migrate

    puts "== Post merge"
    [User, CustomField, Tracker, IssueStatus, Enumeration,
     Project, Version, News, IssueCategory, Issue, IssueRelation, Journal, JournalDetail].each do |model|
      puts "#{model}: #{model.count}"
    end

  end
end
