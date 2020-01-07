class Person < ApplicationRecord
  include ActiveModel::Validations
  
  #Validations
  validates :first_name, :last_name, presence: true, length: { maximum: 30 }
  validates :sex, presence: true, format: { with: /\Amale|female\z/ }
  VALID_EMAIL_REGEX = /[\w+\-.](?<!\.)+@[a-z\d\-.]+(?<!\.)\.[a-z]+/i
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, allow_nil: true
  VALID_PHONE_REGEX = /\A\(?\d{3}[\)\-\.\\]?\d{3}[\-\.\\]?\d{4}\z/
  validates :phone, format: { with: VALID_PHONE_REGEX }, allow_nil: true
  validates_with StateValidator, allow_nil: true, unless: -> (x) { x.nil? }
  validates_with ZipValidator, allow_nil: true, unless: -> (x) { x.nil? }
  validates_with DobValidator, unless: -> (x) { x.nil? }
  validates_with ChildValidator, allow_nil: true

  #Associations
  has_many :children, class_name: "Person", foreign_key: :parent_id
  belongs_to :parent, class_name: "Person", optional: true
  
  has_many :husband_marriages, foreign_key: :husband_id, class_name: "Marriage", inverse_of: :husband
  has_many :wives, through: :husband_marriages

  has_many :wife_marriages, foreign_key: :wife_id, class_name: "Marriage", inverse_of: :wife
  has_many :husbands, through: :wife_marriages

  has_many :leaderships, foreign_key: :leader_id
  has_many :led_ministries, through: :leaderships, source: :ministry

  def married?
    !self.current_spouse.nil?
  end

  def current_marriage
    Marriage.where(husband_id: self.id).or(Marriage.where(wife_id: self.id)).where(end_date: nil).first
  end

  def current_spouse
    if !self.current_marriage.nil?
      current_marriage.husband_id == self.id ? Person.find(current_marriage.wife_id) : Person.find(current_marriage.husband_id)
    end
  end

  def marry spouse, marriage_date
    
  end

  def end_marriage end_date
    if self.married?
      self.current_marriage.update(end_date: end_date)
    end
  end

  def divorce spouse, divorce_date
    if current_spouse == spouse
      self.end_marriage(divorce_date)
    end
  end

  def die dod
    self.date_of_death = dod
    self.end_marriage(dod)
  end

  def living?
    self.date_of_death.nil?
  end
end