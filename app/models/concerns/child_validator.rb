class ChildValidator < ActiveModel::Validator
  
  def validate record
    record.errors[:base] << "Self cannot be child" if record.children.any? { |child| child.parents.include?(child) }
  end
end