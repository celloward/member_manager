class RelationValidator < ActiveModel::Validator
  #Test if attempted marriage to child or self.
  def validate record
    record.errors[:base] << "Self cannot be spouse" if record.husband_id == record.wife_id
    if record.people_exist?
      wife = Person.find(record.wife_id)
      husband = Person.find(record.husband_id)
      record.errors[:base] << "Cannot have child as spouse" if wife.parents.include?(husband) || husband.parents.include?(wife)
    end
  end 
end