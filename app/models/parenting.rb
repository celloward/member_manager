class Parenting < ApplicationRecord

  validates_uniqueness_of :child_id, scope: :parent_id, message: "Cannot have child/parent more than once."

  belongs_to :parent, class_name: "Person"
  belongs_to :child, class_name: "Person"
end
