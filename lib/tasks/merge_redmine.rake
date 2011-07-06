namespace :redmine do
  desc 'Report on the data in the target database'
  task :data_report => :environment do
    [
     User,
     CustomField,
     Tracker,
     IssueStatus,
     Enumeration,
     Project,
     Version,
     News,
     IssueCategory,
     Issue,
     IssueRelation,
     Journal,
     JournalDetail,
     TimeEntry,
     Document,
     Wiki,
     WikiPage,
     WikiContent,
     Attachment
    ].each do |model|
      puts "#{model}: #{model.count}"
    end
  end
  
  desc 'Merge two Redmine databases'
  task :merge_redmine => :environment do
    Thread.current[:planio_account] = ENV['planio_account']
    RedmineMerge.migrate
  end
end
