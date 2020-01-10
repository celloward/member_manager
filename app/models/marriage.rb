class Marriage < ApplicationRecord
  #Must have husband_id AND wife_id AND marriage_date
  #Each party must only have one marriage record where end_date is nil
  #All new marriages must post-date the end_dates of all marriage records for each party
  #Marriage record cannot have same id for both husband and wife
  #husband_id must be male gender and wife_id must be female gender
  #Marriage cannot be with own child

#Validations
  validates :husband, :wife, presence: true
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
    !Person.where(id: self.husband_id).empty? && !Person.where(id: self.wife_id).empty?
  end
end
