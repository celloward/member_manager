class Marriage < ApplicationRecord

#Validations
  validates :husband, :wife, presence: true
  validates :marriage_date, presence: true
  validates_with RelationValidator
  validates_with AvailableValidator, on: :create
  validates_with SexValidator
  validates_with CollisionValidator

  scope :other_marriages, ->(record) { where(husband_id: record.husband_id).or(Marriage.where(wife_id: record.wife_id)) } 
  scope :former, -> { where("end_date IS NOT NULL") }
  scope :current, -> { where(end_date: nil) }
  scope :individual_marriages, ->(id) { where(husband_id: id).or(Marriage.where(wife_id: id)) }

  belongs_to :husband, class_name: "Person"
  belongs_to :wife, class_name: "Person"

  def people_exist?
    Person.where(id: self.husband_id).or(Person.where(id: self.wife_id)).count == 2
  end
end
