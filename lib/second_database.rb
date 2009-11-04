# Abstraction to connect to the second database
module SecondDatabase
  def self.included(base)
    base.class_eval do
      establish_connection :source_redmine
    end
  end
end
