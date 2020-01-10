class AvailableValidator < ActiveModel::Validator
  
  def validate(record)
    current_marriages = Marriage.other_marriages(record).current
    record.errors[:base] << "Husband already married" if current_marriages.any? { |r| r.husband_id == record.husband_id }
    record.errors[:base] << "Wife already married" if current_marriages.any? { |r| r.wife_id == record.wife_id }
  end
end