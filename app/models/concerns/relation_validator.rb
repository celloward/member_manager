class RelationValidator < ActiveModel::Validator
  #Test if attempted marriage to child or self.
  def validate record
    record.errors[:base] << "Self cannot be spouse" if record.husband_id == record.wife_id
    if record.people_exist?
      record.errors[:base] << "Cannot have child as spouse" if record.husband_id == Person.find_by(id: record.wife_id).parent_id || record.wife_id == Person.find_by(id: record.husband_id).parent_id
    end
  end 
end