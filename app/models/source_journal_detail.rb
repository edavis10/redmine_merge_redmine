class SourceJournalDetail < ActiveRecord::Base
  include SecondDatabase
  set_table_name :journal_details

  belongs_to :journal, :class_name => 'SourceJournal', :foreign_key => 'journal_id'
  
  def self.migrate
    all.each do |source_journal_detail|

      jd = JournalDetail.new
      jd.attributes = source_journal_detail.attributes
      jd.journal = Journal.find(RedmineMerge::Mapper.get_new_journal_id(source_journal_detail.journal_id))
      jd.save!

    end
  end
end
