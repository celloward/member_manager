class Marriage < ApplicationRecord
  #Must have husband_id AND wife_id AND marriage_date
  #Each party must only have one marriage record where end_date is nil
  #All new marriages must post-date the end_dates of all marriage records for each party
  #Marriage record cannot have same id for both husband and wife
  #husband_id must be male gender and wife_id must be female gender
  #Marriage cannot be with own child

#Validations
  # validates :husband, :wife
  # validates_with MarriageValidator


  belongs_to :husband, class_name: "Person"
  belongs_to :wife, class_name: "Person"
end
