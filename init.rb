require 'redmine'

require 'second_database'

Redmine::Plugin.register :redmine_merge_redmine do
  author 'Eric Davis'
  url 'https://projects.littlestreamsoftware.com/projects'
  author_url 'http://www.littlestreamsoftware.com'
  description 'A plugin to merge two Redmine databases'
  version '0.0.1'

  requires_redmine :version_or_higher => '0.8.0'
end
