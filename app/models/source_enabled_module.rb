class SourceEnabledModule < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}enabled_modules#{table_name_suffix}"

end
