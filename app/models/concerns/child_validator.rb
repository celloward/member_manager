class ChildValidator < ActiveModel::Validator
  
  def validate record
    if record.children.any? { |child| child.id = child.parent_id }
      record.errors.add :base, "Self cannot be child"
    end
  end
end