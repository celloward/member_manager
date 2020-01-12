class CollisionValidator < ActiveModel::Validator

  include PeopleHelper

  def validate record
    record.end_date.nil? ? end_date = "4000-01-01" : end_date = record.end_date
    Marriage.other_marriages(record).former.each do |marriage|
      # debugger
      if ((to_date(marriage.marriage_date)..to_date(marriage.end_date)).to_a & (to_date(record.marriage_date)..to_date(end_date)).to_a).any?
        record.errors[:base] << "Marriage date collision with #{marriage}" 
      end
    end
  end
end