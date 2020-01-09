class CollisionValidator < ActiveModel::Validator

    # def check_marriage_collisions record
  #   Marriage.other_marriages(record).each do |marriage|
  #     start_date = to_date(marriage.marriage_date)
  #     end_date = to_date(marriage.end_date)
  #     if (start_date..end_date).to_a.include?(to_date(record.marriage_date))
  #       record.errors[:base] << "Marriage date collision with #{marriage}" 
  #     end
  #   end
  # end

  def to_date date
    Date.strptime(date, "%Y-%m-%d")
  end
end