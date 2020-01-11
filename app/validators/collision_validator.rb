class CollisionValidator < ActiveModel::Validator

  include PeopleHelper

  def validate record
    Marriage.other_marriages(record).former.each do |marriage|
      end_date = "4000-01-01" if marriage.end_date.nil?
      if (to_date(marriage.marriage_date)..to_date(marriage.end_date)).to_a.include?(to_date(record.marriage_date))
        record.errors[:base] << "Marriage date collision with #{marriage}" 
      end
    end
  end
end