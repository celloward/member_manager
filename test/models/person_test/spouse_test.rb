require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  setup do
    @person.save
    @spouse.save
    @secondspouse = Person.create(first_name: "Second", last_name: "Person", sex: "female")
    @thirdspouse = Person.create(first_name: "Other", last_name: "Somebody", sex: "male")
  end

  test "#current_spouse finds opposite spouse with no end date" do
    Marriage.create(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-01-01")
    assert_equal @person.current_spouse, @spouse
    assert_equal @spouse.current_spouse, @person
  end

  test "#current_spouse returns empty if all spouses have end dates" do
    assert_not @person.current_spouse
    Marriage.create(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-01-01", end_date: "2029-01-01")
    assert_not @person.current_spouse
    Marriage.create(husband_id: @person.id, wife_id: @secondspouse.id, marriage_date: "2030-01-01")
    assert_equal @person.current_spouse, @secondspouse
  end

  test "#married? returns true if there is a current spouse" do
    assert_not @spouse.married?
    Marriage.create(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-01-01")
    assert @spouse.married?
    m1 = Marriage.find_by(wife_id: @spouse.id)
    m1.end_date = "2029-01-01"
    m1.save
    assert_not @spouse.married?
    assert_not @person.married?
  end

  test "#marry creates an active marriage between two people" do
    assert_not Marriage.find_by(husband_id: @person.id)
    @person.marry(@spouse, "2020-01-01")
    assert m1 = Marriage.find_by(husband_id: @person.id)
    m1.update(end_date: "2030-02-12")
    @secondspouse.marry(@person, "2031-01-02")
    assert Marriage.find_by(wife_id: @secondspouse.id)
  end

  test "can be married" do
    Marriage.create(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-02-01")
    assert @person.married?
    assert @person.valid?
  end

  test "can be unmarried" do
    assert_not @person.married?
    assert @person.valid?
  end

  test "cannot #marry when either has current spouse" do
    @person.marry(@spouse, "2020-01-01")
    @secondspouse.marry(@thirdspouse, "2020-01-02")
    assert_raises { @person.marry(@spouse, "2030-01-01") }
    assert_raises { @person.marry(@secondspouse, "2030-01-01") }
    @person.divorce(@spouse, "2025-01-01")
    assert_raises { @person.marry(@secondspouse, "2030-01-01") }
    @secondspouse.divorce(@thirdspouse, "2025-01-01")
    assert @person.marry(@secondspouse, "2030-01-01")
  end

  test "can have former spouse and current spouse" do
    Marriage.create(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-01-01", end_date: "2027-02-01")
    Marriage.create(husband_id: @person.id, wife_id: @secondspouse.id, marriage_date: "2030-02-01")
    assert @person.valid?
    assert_equal @person.current_spouse, @secondspouse
    assert_equal @person.wives.count, 2
    assert_equal @secondspouse.current_spouse, @person
    assert_equal @spouse.husbands.count, 1
    assert_equal @secondspouse.husbands.count, 1
  end

  test "can have former spouse through #die" do
    Marriage.create(husband_id: @person.id, wife_id: @secondspouse.id, marriage_date: "2020-01-01")
    @secondspouse.die("2020-12-12")
    assert_not @person.married?
    assert_not @secondspouse.married?
    assert @person.wives.all?(Person.find(@secondspouse.id))
    assert @secondspouse.husbands.all?(Person.find(@person.id))
  end

  test "can create former spouses through #divorce" do
    Marriage.create(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-01-01")
    assert_equal @person.current_spouse, @spouse
    assert_equal @spouse.current_spouse, @person
    @person.divorce(@spouse, "2030-02-01")
    assert_not @person.married?
    assert_not @spouse.married?
    assert @person.wives.all?(Person.find(@spouse.id))
    assert @spouse.husbands.all?(Person.find(@person.id))
  end
end