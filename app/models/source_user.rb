class SourceUser < ActiveRecord::Base
  establish_connection :source_redmine
  set_table_name :users
end
