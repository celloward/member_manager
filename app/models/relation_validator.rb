class RelationValidator < ActiveModel::Validator
  
  def validate record
    record.errors[:base] << "Self cannot be spouse" if record.husband_id == record.wife_id
    if record.people_exist?
      record.errors[:base] << "Cannot have child as spouse" if Person.joins(:parents).where(id: record.wife_id).where(parentings: { parent_id: record.husband_id }).or(Person.joins(:parents).where(id: record.husband_id).where(parentings: { parent_id: record.wife_id })).exists?
    end
  end 
end