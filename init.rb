require 'redmine'

require 'second_database'

Redmine::Plugin.register :redmine_merge_redmine do
  author 'Eric Davis & Christian Rodriguez'
  url 'https://projects.littlestreamsoftware.com/projects'
  author_url 'http://www.littlestreamsoftware.com'
  description 'A plugin to merge two Redmine databases'
  version '0.1.0'

  requires_redmine :version_or_higher => '2.0.0'
end
