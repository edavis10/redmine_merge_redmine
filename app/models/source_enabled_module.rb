class SourceEnabledModule < ActiveRecord::Base
  include SecondDatabase
  set_table_name :enabled_modules

end
