class SourceUser < ActiveRecord::Base
  include SecondDatabase
  set_table_name :users
end
