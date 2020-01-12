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
    @fourthspouse = Person.create(id: 10, first_name: "Outa", last_name: "Leftfield", sex: "female")
    @m1 = Marriage.new(husband_id: @person.id, wife_id: @fourthspouse.id, marriage_date: "2020-01-01")
    assert @m1.valid?
  end

  test "validates presence of marriage_date" do
    assert @m1.valid?
    @m1.marriage_date = nil
    assert @m1.invalid?
  end

  test "validates end date cannot be before marriage_date" do
    @m1.end_date = "2000-01-01"
    assert @m1.invalid?
  end

  test "validates husbands are male and wives are female" do
    @m1.wife_id = @thirdspouse.id
    assert @m1.invalid?
    @m1.husband_id = @secondspouse.id
    assert @m1.invalid?
    @m1.wife_id = @spouse.id
    assert @m1.invalid?
    @m1.husband_id = @thirdspouse.id
    assert @m1.valid?
  end

  test "validates self cannot be spouse" do
    @m1.wife_id = @person.id
    assert @m1.invalid?
  end

  test "cannot have child as spouse" do
    assert @m1.valid?
    @person.children << @spouse
    assert @m1.invalid?
  end

  test "cannot have more than one current marriage" do
    @m1.save
    @m2 = Marriage.new(husband_id: @person.id, wife_id: @secondspouse.id, marriage_date: "2022-01-01")
    assert_not @m2.valid?
    @m1.update(end_date: "2021-01-01")
    assert @m2.valid?
  end

  test "cannot have marriage date inside other marriage dates for same person" do
    @m1.end_date = "2030-01-01"
    @m1.save
    @m2 = Marriage.new(husband_id: @thirdspouse.id, wife_id: @spouse.id, marriage_date: "2025-01-01")
    assert @m2.invalid?
    @m2.marriage_date = "2030-01-02"
    assert @m2.valid?
  end

  test "can marry same person outside of original date range" do
    @m1.end_date = "2030-01-01"
    @m1.save
    @m2 = Marriage.new(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2029-01-02")
    assert @m2.invalid?
    @m2.marriage_date = "2032-01-01"
    assert @m2.valid?
  end

  test "cannot update marriage dates to collide with other relevant marriages" do
    @m1.end_date = "2025-01-01"
    @m1.save
    @m2 = Marriage.create(husband_id: @thirdspouse.id, wife_id: @spouse.id, marriage_date: "2026-01-01", end_date: "2030-02-01")
    @m1.update(end_date: "2027-01-01")
    # debugger
    assert @m1.invalid?
    assert @m2.valid?
    @m1 = Marriage.find(1)
    @m2.update(marriage_date: "2024-01-01")
    assert @m2.invalid?
    assert @m1.valid?
  end
  
  test "can add previous marriages even if in current marriage" do
    @m1.save
    @m2 = Marriage.new(husband_id: @person.id, wife_id: @secondspouse.id, marriage_date: "1980-01-01", end_date: "1999-01-01")
    assert @m2.valid?
    assert @m1.valid?
  end
end
