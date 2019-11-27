class Member < ApplicationRecord
  belongs_to :state
  has_many :leaderships, foreign_key: :leader_id
  has_many :led_ministries, through: :leaderships, source: :ministry
end