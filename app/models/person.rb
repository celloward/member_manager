class Person < ApplicationRecord
  include ActiveModel::Validations
  
  #Validations
  validates :first_name, :last_name, presence: true, length: { maximum: 30 }
  validates :sex, presence: true, format: { with: /\Amale|female\z/ }
  VALID_EMAIL_REGEX = /[\w+\-.](?<!\.)+@[a-z\d\-.]+(?<!\.)\.[a-z]+/i
  VALID_PHONE_REGEX = /\A\(?\d{3}[\)\-\.\\]?\d{3}[\-\.\\]?\d{4}\z/
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, unless: Proc.new { |person| person.email.nil? }
  validates :phone, format: { with: VALID_PHONE_REGEX }, unless: Proc.new { |person| person.phone.nil? }
  validates_with StateValidator, unless: Proc.new { |person| person.state.nil? }
  validates_with ZipValidator, unless: Proc.new { |person| person.zipcode.nil? }, :field => :state
  validates_with DobValidator, unless: Proc.new { |person| person.dob.nil? }
  validates_with ChildValidator, unless: Proc.new { |person| person.children.nil? }

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
    Marriage.individual_marriages(self.id).current.first
  end

  def current_spouse
    cm = current_marriage
    unless cm.nil?
      cm.husband_id == self.id ? Person.find(cm.wife_id) : Person.find(cm.husband_id)
    end
  end

  def marry spouse, marriage_date
    if self.sex == "male"
      husband = self
      wife = spouse 
    else
      husband = spouse
      wife = self
    end
    marriage = Marriage.new(husband_id: husband.id, wife_id: wife.id, marriage_date: marriage_date)
    if marriage.valid?
      marriage.save
    else
      marriage.errors.full_messages.each { |error| raise StandardError.new "#{error}" }
    end
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