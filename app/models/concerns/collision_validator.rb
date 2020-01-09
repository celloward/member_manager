class CollisionValidator < ActiveModel::Validator

  def validate record
    Marriage.other_marriages(record).former.each do |marriage|
      if (to_date(marriage.marriage_date)..to_date(marriage.end_date)).to_a.include?(to_date(record.marriage_date))
        record.errors[:base] << "Marriage date collision with #{marriage}" 
      end
    end
  end

  def to_date date
    Date.strptime(date, "%Y-%m-%d")
  end
end