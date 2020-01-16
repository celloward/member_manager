class RecursiveValidator < ActiveModel::Validator

  def validate record
    record.errors[:base] << "Cannot have child who is also parent" if Parenting.where(parent_id: record.child_id, child_id: record.parent_id).exists?
  end
end