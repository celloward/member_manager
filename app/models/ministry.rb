class Ministry < ApplicationRecord
  has_many :leaderships, foreign_key: :ministry_id
  has_many :leaders, through: :leaderships
end
