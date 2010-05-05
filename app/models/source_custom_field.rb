class SourceCustomField < ActiveRecord::Base
  include SecondDatabase
  set_table_name :custom_fields

  def self.migrate
    all.each do |source_custom_field|
      next if CustomField.find_by_name(source_custom_field.name)

      CustomField.create!(source_custom_field.attributes)
    end
  end
end
