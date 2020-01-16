class RecursiveValidator < ActiveModel::Validator

  def validate record
    record.errors[:base] << "Cannot have child who is also parent" if Parenting.where(parent_id: record.child_id, child_id: record.parent_id).exists?
  end
    # Person.find_by_sql("SELECT * FROM people AS parentsx JOIN parentings ON parentsx.id = parentings.parent_id JOIN people AS childrenx ON parentings.child_id = childrenx.id WHERE parentsx.id IN (SELECT parentings.child_id FROM parentings JOIN people AS parentsy ON parentsy.id = parentings.parent_id WHERE parentsy.id = childrenx.id)").any?
end