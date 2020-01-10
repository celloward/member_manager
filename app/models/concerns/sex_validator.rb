class SexValidator < ActiveModel::Validator

  def validate record
    if record.people_exist?
      if Person.find(record.husband_id).sex != "male"
      record.errors[:base] << "Husband must be male"
      elsif Person.find(record.wife_id).sex != "female" 
      record.errors[:base] << "Wife must be female" 
      end
    end
  end
end