class SourceMember < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}members#{table_name_suffix}"

  belongs_to :user, :class_name => 'SourceUser', :foreign_key => 'user_id'
  belongs_to :project, :class_name => 'SourceProject', :foreign_key => 'project_id'
  has_many :member_roles, :class_name => 'SourceMemberRole', :foreign_key => 'member_id'
  def self.migrate
    all.each do |source_member|

      Member.create!(source_member.attributes.except('user_id','project_id')) do |m|
        m.project = Project.find(RedmineMerge::Mapper.get_new_project_id(source_member.project_id))
        m.user = User.find_by_login(source_member.user.login)
        source_member.member_roles.each do |member_role|
          m.member_roles << MemberRole.new(:role => Role.find_by_name(member_role.role.name), 
                                           :inherited_from => member_role.inherited_from && Role.find(member_role.inherited_from))
        end
      end

    end
  end
end
