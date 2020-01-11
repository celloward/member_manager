class RelationValidator < ActiveModel::Validator
  def validate record
    record.errors[:base] << "Self cannot be spouse" if record.husband_id == record.wife_id
    if record.people_exist?
      wife, husband = Person.find(record.wife_id), Person.find(record.husband_id)
      record.errors[:base] << "Cannot have child as spouse" if wife.parents.include?(husband) || husband.parents.include?(wife)
    end
  end 
end