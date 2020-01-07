class MarriageValidator < ActiveModel::Validator
  
  def validate(record)
    if Person.find(record.husband_id).sex != "male"
      record.errors[:base] << "Husband must be male"
    elsif Person.find(record.wife_id).sex != "female" 
      record.errors[:base] << "Wife must be female" 
    end
    all_marriages = Marriage.where(husband_id: record.husband_id).or(Marriage.where(wife_id: record.wife_id))
    if all_marriages.any?
      all_marriages.each do |marriage|
        if marriage.end_date.nil?
          if marriage.husband_id == record.husband_id
            record.errors[:base] << "Husband already married" 
          elsif marriage.wife_id = record.wife_id
            record.errors[:base] << "Wife already married" 
          end
        end
        start_date = to_date(marriage.marriage_date)
        end_date = to_date(marriage.end_date)
        if (start_date..end_date).to_a.include?(to_date(record.marriage_date))
          record.errors[:base] << "Marriage date collision with #{marriage}" 
        end
      end
    end
  end

  def to_date date
    Date.strptime(date, "%Y-%m-%d")
  end

end