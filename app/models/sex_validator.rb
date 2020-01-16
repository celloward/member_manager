class SexValidator < ActiveModel::Validator

  def validate record
    if record.people_exist?
      if !Person.where(id: record.husband_id).where(sex: "male").exists?
      record.errors[:base] << "Husband must be male"
      elsif !Person.where(id: record.wife_id).where(sex: "female").exists?
      record.errors[:base] << "Wife must be female" 
      end
    end
  end
end