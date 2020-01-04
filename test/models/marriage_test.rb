require 'test_helper'

class MarriageTest < ActiveSupport::TestCase
  
  setup do
    @person = Person.create(first_name: "First", last_name: "Person", sex: "male")
    @spouse = Person.create(first_name: "Second", last_name: "Person", sex: "female")
    @secondspouse = Person.create(first_name: "Newbie", last_name: "Person", sex: "female")
    @thirdspouse = Person.create(first_name: "Other", last_name: "Somebody", sex: "male")
    @m1 = Marriage.new(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-01-01")
  end

  test "validates references to husband and wife" do
    assert @m1.valid?
    @m2 = Marriage.new(husband_id: @thirdspouse.id, marriage_date: "2020-01-01")
    assert_not @m2.valid?
    @m1.wife_id = 10
    assert_not @m1.valid?
    @m2 = Marriage.new(husband_id: @thirdspouse.id, wife_id: @secondspouse.id, marriage_date: "2020-01-01")
    assert @m2.valid?
  end

  test "validates husbands are male and wives are female" do
    @m1.wife_id = @thirdspouse.id
    assert_not @m1.valid?
    @m1.husband_id = @secondspouse.id
    assert_not @m1.valid?
    @m1.wife_id = @spouse.id
    assert_not @m1.valid?
    @m1.husband_id = @thirdspouse.id
    assert @m1.valid?
  end

  test "validates self cannot be spouse" do
    @m1.wife_id = @person.id
    assert_not @m1.valid?
  end

  test "cannot have child as spouse" do
    assert @m1.valid?
    @person.children << @spouse
    @person.save
    assert_not @m1.valid?
  end

  test "cannot have more than one current marriage" do
    @m1.save
    @m2 = Marriage.new(husband_id: @person, wife_id: @secondspouse, marriage_date: "2022-01-01")
    assert_not @m2.valid?
    @m1.update(end_date: "2021-01-01")
    @m1.save
    assert @m2.valid?
  end

  test "cannot have marriage date inside other marriage dates for same person" do
    @m1.end_date = "2030-01-01"
    @m1.save
    @m2 = Marriage.new(husband_id: @thirdspouse, wife_id: @spouse, marriage_date: "2025-01-01")
    assert_not @m2.valid?
    @m2.marriage_date = "2030-01-02"
    assert @m2.valid?
  end

  test "can marry same person outside of original date range" do
    @m1.end_date = "2030-01-01"
    @m1.save
    @m2 = Marriage.new(husband_id: @person, wife_id: @spouse, marriage_date: "2029-01-02")
    assert_not @m2.valid?
    @m2.marriage_date = "2032-01-01"
    assert @m2.valid?
  end

    
end
