class Leadership < ApplicationRecord
  belongs_to :ministry
  belongs_to :leader, class_name: "Person"
end
