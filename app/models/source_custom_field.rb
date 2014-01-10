class SourceCustomField < ActiveRecord::Base
  include SecondDatabase
  self.table_name = "#{table_name_prefix}custom_fields#{table_name_suffix}"

  def self.migrate
    all.each do |source_custom_field|
      next if CustomField.find_by_name(source_custom_field.name)

      CustomField.create!(source_custom_field.attributes)
    end
  end
end
