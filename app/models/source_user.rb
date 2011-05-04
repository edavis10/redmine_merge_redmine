class SourceUser < ActiveRecord::Base
  include SecondDatabase
  set_table_name :users

  def self.migrate
    all.each do |source_user|
      next if source_user.login.blank? ## ignore the illegal user record in DB
      next if source_user.type == "AnonymousUser"
      user = User.find_by_mail(source_user.mail)
      user = User.find_by_login(source_user.login) unless user
      
      user = User.create!(source_user.attributes) do |u|
        u.login = source_user.login
        u.admin = source_user.admin
        u.hashed_password = source_user.hashed_password
      end unless user
      RedmineMerge::Mapper.add_user(source_user.id, user.id)
    end
  end
end
