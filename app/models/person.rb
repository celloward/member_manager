class Person < ApplicationRecord
  include ActiveModel::Validations
  
  #Validations
  validates :first_name, :last_name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /[\w+\-.](?<!\.)+@[a-z\d\-.]+(?<!\.)\.[a-z]+/i
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, unless: Proc.new { |person| person.email.nil? }
  VALID_PHONE_REGEX = /\A\(?\d{3}[\)\-\.\\]?\d{3}[\-\.\\]?\d{4}\z/
  validates :phone, format: { with: VALID_PHONE_REGEX }, unless: Proc.new { |person| person.phone.nil? }
  validates_with StateValidator, unless: Proc.new { |person| person.state.nil? }
  validates_with ZipValidator, unless: Proc.new { |person| person.zipcode.nil? }, :field => :state
  validates_with DobValidator, unless: Proc.new { |person| person.dob.nil? }
  validates_with ChildValidator, unless: Proc.new { |person| person.children.nil? }
  validates_with SpouseValidator, unless: Proc.new { |person| person.spouse.nil? }

  #Associations
  has_many :children, class_name: "Person", foreign_key: :parent_id
  belongs_to :parent, class_name: "Person", optional: true
  
  has_one :spouse, class_name: "Person", foreign_key: :spouse_id
  belongs_to :spouse, class_name: "Person", optional: true
  has_many :former_spouses, class_name: "Person", foreign_key: :former_spouse_id
  belongs_to :former_spouse, class_name: "Person", optional: true
  
  has_many :leaderships, foreign_key: :leader_id
  has_many :led_ministries, through: :leaderships, source: :ministry

  private
    def validate_child child
      if child.id == child.parent_id
        child.errors.add :base, "Self cannot be child"
      end
    end
end