class SourceMemberRole < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}member_roles#{table_name_suffix}"

  belongs_to :member, :class_name => 'SourceMember', :foreign_key => 'member_id'
  belongs_to :role, :class_name => 'SourceRole', :foreign_key => 'role_id'
end
