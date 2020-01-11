class Person < ApplicationRecord
  include ActiveModel::Validations
  
  #Validations
  validates :first_name, :last_name, presence: true, length: { maximum: 30 }
  validates :sex, presence: true, format: { with: /\Amale|female\z/ }
  VALID_EMAIL_REGEX = /[\w+\-.](?<!\.)+@[a-z\d\-.]+(?<!\.)\.[a-z]+/i
  VALID_PHONE_REGEX = /\A\(?\d{3}[\)\-\.\\]?\d{3}[\-\.\\]?\d{4}\z/
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, unless: -> { email.nil? }
  validates :phone, format: { with: VALID_PHONE_REGEX }, unless: -> { phone.nil? }
  validates_with StateValidator, unless: -> { state.nil? }
  validates_with ZipValidator, unless: -> { zipcode.nil? }
  validates_with DobValidator, unless: -> { dob.nil? }
  validates_with ChildValidator, unless: -> { children.nil? }

  #Associations
  has_many :parental_relations, foreign_key: :parent_id, class_name: "Parenting", inverse_of: :parent
  has_many :children, through: :parental_relations, source: :child

  has_many :childings, foreign_key: :child_id, class_name: "Parenting", inverse_of: :child
  has_many :parents, through: :childings, source: :parent

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
    husband, wife = self, spouse
    husband, wife = spouse, self if self.sex == "female"
    marriage = Marriage.new(husband_id: husband.id, wife_id: wife.id, marriage_date: marriage_date)
    joint_children = husband.children
    joint_children << wife.children
    joint_children.each do |child| 
      husband.children << child unless husband.children.include?(child)
      wife.children << child unless wife.children.include?(child)
    end
    marriage.valid? ? marriage.save : marriage.errors.full_messages.each { |error| raise StandardError.new "#{error}" }
  end

  def end_marriage end_date
    self.current_marriage.update(end_date: end_date) if self.married?
  end

  def divorce spouse, divorce_date
    self.end_marriage(divorce_date) if current_spouse == spouse
  end

  def die dod
    self.date_of_death = dod
    self.end_marriage(dod)
  end

  def living?
    self.date_of_death.nil?
  end
end