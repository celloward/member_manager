require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_seed
    @person = Person.new(first_name: "Example", last_name: "Person")
    @child = Person.new(first_name: "Junior", last_name: "Person")
    @spouse = Person.new(first_name: "Spouse", last_name: "Person")
  end

  test "can be a member" do
  end

  test "can be a non-member" do
  end

  #Validations
  test "should be valid" do
    assert @person.valid?
  end

  test "first and last name should be present" do
    @person.first_name = "   "
    @person.last_name = "  "
    assert_not @person.valid?
  end

  test "state validation should reject invalid entries" do
    invalid_state = %w[ILA ZD md]
    invalid_state.each do |invalid_state|
      @person.state = invalid_state
      assert_not @person.valid?, "#{invalid_state} should be valid"
    end
  end

  test "state validation should accept valid entries" do
    @person.state = "MD"
    assert @person.valid?
  end

  test "email validation should accept valid email addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.barr.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @person.email = valid_address
      assert @person.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid email addresses" do
    invalid_addresses = %w[user@example,com user..@gmail.com user@msn..com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @person.email = invalid_address
      assert_not @person.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "zipcode validation should reject invalid entries" do
    @person.state = "VA"
    invalid_zipcodes = %w[240189 213 15ds6 00000 60660]
    invalid_zipcodes.each do |invalid_zipcode|
      @person.zipcode = invalid_zipcode
      assert_not @person.valid?, "#{invalid_zipcode} should be invalid"
    end
  end

  test "zipcode validation should accept valid entries" do
    @person.state = "VA"
    @person.zipcode = "24018"
    assert @person.valid?
  end

  test "phone validation should reject invalid entries" do
    invalid_phone = %w[11234567890 12-345-67890 123s456a7890]
    invalid_phone.each do |invalid_phone|
      @person.phone = invalid_phone
      assert_not @person.valid?, "#{invalid_phone} should be invalid"
    end
  end

  test "phone validation should accept valid entries" do
    valid_phone = %w[1234567890 123-456-7890 123.456.7890 (123)456-7890]
    valid_phone.each do |valid_phone|
      @person.phone = valid_phone
      assert @person.valid?, "#{valid_phone} should be valid"
    end
  end

  test "dob validation rejects invalid entries" do
    invalid_dob = %w[1-2-2000 01022000 01-02-99 30-11-2000 11-32-2000 11-30-3000 11-30-1850]
    invalid_dob.each do |dob|
      @person.dob = dob
      assert_not @person.valid?, "#{dob} should be invalid"
    end
  end

  test "dob validation accepts valid entries" do
    valid_dob = %w[01-02-2000 01/02/2000]
    valid_dob.each do |dob|
      @person.dob = dob
      assert @person.valid?, "#{dob} should be valid"
    end
  end

  #Associations with Self(Children)
  test "can have children" do
    @person.save
    @child.save
    @person.children << @child
    assert @person.children.first == @child
  end

  test "can have no children" do
    assert @person.children.blank?
  end

  test "cannot have self as child" do
    @person.save
    @person.children << @person
    assert_not @person.valid?
  end

  #Associations with Self(Spouse)
  test "can have spouse" do
    @person.save
    @spouse.save
    @person.spouse = @spouse
    assert @person.spouse == @spouse
  end

  test "can have no spouse" do
    assert @person.spouse.blank?
  end

  test "cannot have more than one living spouse" do
    @person.save
    @spouse.save
    @secondspouse = Person.new(first_name: "Second", last_name: "Person")
    @secondspouse.save
    @person.spouses << @spouse
    @person.spouses << @secondspouse
    assert_not @person.valid?
    @person.spouses.pop
    @spouse.living = false
    @person.spouses << @secondspouse
    assert @person.valid?
  end

  test "cannot have self as spouse" do
    assert_raise { @person.spouse << @person }
  end

  test "cannot have child as spouse" do
    @person.children << @child
    assert_raise { @person.spouse << @person.child }
  end
  
  #Associations with Ministry
  # test "people can lead a ministry" do
  #   worship = Ministry.create(name: "Worship")
  #   worship.leader = Person.find_by(first_name: "c")
  #   assert worship.leader
  #   assert_not_equal worship.leader, Person.find_by(first_name: "b")
  # end

end
