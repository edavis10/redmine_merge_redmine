namespace :redmine do
  desc 'Merge two Redmine databases'
  task :merge_redmine => :environment do
    RedmineMerge.migrate
  end
end
