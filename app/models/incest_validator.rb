class IncestValidator < ActiveModel::Validator

  def validate record
    record.errors[:base] << "Spouse cannot be child" if Marriage.where(husband_id: record.child_id).where(wife_id: record.parent_id).or(Marriage.where(wife_id: record.child_id).where(husband_id: record.parent_id)).exists?
  end
end