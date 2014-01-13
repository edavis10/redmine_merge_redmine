class SourceRole < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}roles#{table_name_suffix}"

  belongs_to :user, :class_name => 'SourceUser', :foreign_key => 'user_id'
  belongs_to :project, :class_name => 'SourceProject', :foreign_key => 'project_id'
  serialize :permissions, ::Role::PermissionsAttributeCoder
  has_many :member_roles, :class_name => 'SourceMemberRole'

  def self.migrate
    all.each do |source_role|
      next if Role.find_by_name(source_role.name)
      Role.create!(source_role.attributes)
    end
  end
end
