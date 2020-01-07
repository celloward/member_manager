class MarriageValidator < ActiveModel::Validator
  
  def validate(record)
    record.errors.add[:base], "Husband must be male" if Person.find(record.husband_id).sex != "male"
    record.errors.add[:base], "Wife must be female" if Person.find(record.wife_id).sex != "female"
    all_marriages = Marriage.where(husband_id: record.husband_id).or(Marriage.where(wife_id: record.wife_id))
    all_marriages.all.each do |marriage|
      if marriage.end_date.nil?
        record.errors.add[:base], "Husband already married" if marriage.husband_id == record.husband_id
        record.errors.add[:base], "Wife already married" if marriage.wife_id = record.wife_id
      end
      start_date = to_date(marriage.marriage_date)
      end_date = to_date(marriage.end_date)
      record.errors.add[:base], "Marriage date collision with #{marriage}" if (start_date..end_date).to_a.include?(to_date(record.marriage_date))
    end
  end

  def to_date date
    Date.strptime(date, "%Y-%m-%d")
  end

end