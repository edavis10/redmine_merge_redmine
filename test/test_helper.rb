# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

class Test::Unit::TestCase

  def self.should_add_each_record_from_the_source_to_the_destination(model, count, &block)
    should "add each record from the source database to the destination database" do
      assert_difference("#{model}.count", count) do
        instance_eval &block
      end
    end
  end
  
end

# Override the actual second database connection code in order to test
# against a known database
module SecondDatabase
  def self.included(base)
    base.class_eval do
      establish_connection("adapter" => 'sqlite3', "database" => File.expand_path(File.dirname(__FILE__) + '/test_database.sqlite3'))
    end
  end
  
end
