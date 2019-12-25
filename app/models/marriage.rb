class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "Person", optional: true
  belongs_to :wife, class_name: "Person", optional: true
end
