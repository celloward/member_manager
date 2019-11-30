class Person < ApplicationRecord
  include ActiveModel::Validations

  validates :first_name, :last_name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /[\w+\-.](?<!\.)+@[a-z\d\-.]+(?<!\.)\.[a-z]+/i
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, unless: Proc.new { |person| person.email.nil? }
  VALID_PHONE_REGEX = /\A\(?\d{3}[\)\-\.\\]?\d{3}[\-\.\\]?\d{4}\z/
  validates :phone, format: { with: VALID_PHONE_REGEX }, unless: Proc.new { |person| person.phone.nil? }
  validates_with StateValidator, unless: Proc.new { |person| person.state.nil? }
  validates_with ZipValidator, unless: Proc.new { |person| person.zipcode.nil? }, :field => :state
  validates_with DobValidator, unless: Proc.new { |person| person.dob.nil? }

  # has_many :children, class_name: "Person", foreign_key: :parent_id
  # has_one :spouse, class_name: "Person", foreign_key: :spouse
  has_many :leaderships, foreign_key: :leader_id
  has_many :led_ministries, through: :leaderships, source: :ministry
end