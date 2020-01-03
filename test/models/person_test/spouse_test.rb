require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  setup do
    @person.save
    @spouse.save
    @secondspouse = Person.new(first_name: "Second", last_name: "Person", gender: "female")
    @secondspouse.save
  end

  test "#current_spouse finds opposite spouse with no end date" do
    Marriage.create(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-01-01")
    assert_equal @person.current_spouse, @spouse
    assert_equal @spouse.current_spouse, @person
  end

  test "#current_spouse returns nil if all spouses have end dates" do
    assert_not @person.current_spouse
    Marriage.create(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-01-01", end_date: "2029-01-01")
    assert_not @person.current_spouse
    Marriage.create(husband_id: @person.id, wife_id: @secondspouse.id, marriage_date: "2020-01-01")
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
    marriage1 = Marriage.find_by(husband_id: @person.id)
    assert_not marriage1
    @person.marry(@spouse)
    assert marriage1
    marriage1.end_date = "2030-02-12"
    @secondspouse.marry(@person)
    assert Marriage.find_by(wife_id: secondspouse.id)
  end

  test "can be married" do
    Marriage.create(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-02-01")
    assert @person.married?
    assert_equal @person.current_spouse, @spouse
    assert_equal @spouse.current_spouse, @person
  end

  test "can be unmarried" do
    assert_not @person.married?
    assert @person.valid?
  end

  test "cannot have self as spouse" do
    assert_raise { @person.wives << @person }
    assert_raise { @person.husbands << @person }
  end

  test "cannot have child as spouse" do
    @person.children << @child
    assert_raise { @person.wives << @person.child }
  end

  test "cannot have duplicate current marriages to same person" do
    @person.marry(@spouse)
    assert_raise { @person.wives << @spouse }
    assert_raise { @spouse.husbands << @person }
    @spouse.die
    assert_equal @person.wives, @spouse
    assert_not @person.current_sposue
    assert_equal @spouse.husbands, @person
    assert_not @spouse.current_spouse
    @person << @secondspouse
    assert_not @person.wives.current
    @person.marry(@secondspouse)
    assert @person.valid?
    assert_equal @person.current_spouse, @secondspouse
    assert_equal @spouse.husbands, @person
    assert_equal @secondspouse.current_spouse, @person
  end

  test "cannot have more than one current spouse" do
    Marriage.create(husband_id: @person.id, wife_id: @spouse.id, marriage_date: "2020-01-01")
    m2 = Marriage.new(husband_id: @person.id, wife_id: @secondspouse.id, marriage_date: "2020-02-01")
    assert_not m2.valid?
    @secondspouse.gender = "male"
    Marriage.new(husband_id: @secondspouse.id, wife_id: @spouse)
    assert_equal @person.wives, @spouse
    assert_eqaul @spouse.husbands, @person
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
    @person.marry(@secondspouse)
    @secondspouse.die("2020-13-12")
    assert_not @person.married?
    assert_not @seconspouse.married?
    assert_equal @person.wives, @secondspouse
    assert_equal @secondspouse.husbands, @person
  end

  test "can create former spouses through #divorce" do
    @person.marry(@spouse)
    assert_equal @person.current_spouse, @spouse
    assert_equal @spouse.current_spouse, @person
    @person.divorce(@spouse)
    assert_not @person.married?
    assert_not @spouse.married?
    assert_equal @person.wives, @spouse
    assert_equal @spouse.husbands, @person
  end
end