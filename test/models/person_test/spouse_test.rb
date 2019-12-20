require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  setup do
    @person.save
    @spouse.save
    @secondspouse = Person.new(first_name: "Second", last_name: "Person", gender: "female")
    @secondspouse.save
  end

  test "can be married" do
    @person.marry(@spouse)
    assert_equal @person.married?, true
    assert_equal @person.wives.current, @spouse
    assert_equal @spouse.husbands.current, @person
  end

  test "can be unmarried" do
    assert_equal @person.married?, false
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
    assert_equal @person.wives.current, nil
    assert_equal @spouse.husbands, @person
    assert_equal @spouse.husbands.current, nil
    @person << @secondspouse
    assert_equal @person.wives.current, nil
    @person.marry(@secondspouse)
    assert @person.valid?
    assert_equal @person.wives.current, @secondspouse
    assert_equal @spouse.husbands, @person
    assert_equal @secondspouse.husbands.current, @person
  end

  test "cannot have more than one current spouse" do
    @person.marry(@spouse)
    assert_raise { @person.marry(@secondspouse) }
    @secondspouse.gender = "male"
    assert_raise { @spouse.marry(@secondspouse) }
    assert_equal @person.wives, @spouse
    assert_eqaul @spouse.husbands, @person
  end

  test "can have former spouse and current spouse" do
    @person.wives << @spouse
    @person.marry(@secondspouse)
    assert @person.valid?
    assert_equal @person.wives.current, @secondspouse
    assert_eqaul @person.wives.count, 2
    assert_equal @spouse.husbands.current, @person
    assert_equal @spouse.husbands.count, 1
    assert_equal @secondspouse.husbands.count, 1
  end

  test "can have former spouse thorugh death" do
    @person.marry(@secondspouse)
    @secondspouse.die
    assert_equal @person.married?, false
    assert_equal @seconspouse.married?, false
    assert_equal @person.wives, @secondspouse
    assert_equal @secondspouse.husbands, @person
  end

  test "can create former spouses through divorce" do
    @person.marry(@spouse)
    assert_equal @person.wives.current, @spouse
    assert_equal @spouse.husbands.current, @person
    @person.divorce(@spouse)
    assert_equal @person.married?, false
    assert_eqaul @spouse.married?, false
    assert_equal @person.wives, @spouse
    assert_equal @spouse.husbands, @person
  end
end