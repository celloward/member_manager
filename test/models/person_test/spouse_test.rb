require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  setup do
    @person.save
    @spouse.save
    @secondspouse = Person.new(first_name: "Second", last_name: "Person")
    @secondspouse.save
  end

  test "can be married" do
    @person.marry(@spouse)
    assert_equal @person.spouses.married, @spouse
    assert_equal @spouse.spouses.married, @person
  end

  test "can be unmarried" do
    assert_equal @person.spouses.married, nil
    assert @person.valid?
  end

  test "cannot have self as spouse" do
    assert_raise { @person.spouses << @person }
  end

  test "cannot have child as spouse" do
    @person.children << @child
    assert_raise { @person.spouses << @person.child }
  end

  test "cannot have duplicate current marriages to same person" do
    @person.marry(@spouse)
    assert_raise { @person.spouses << @spouse }
    assert_raise { @spouse.spouses << @person }
    @spouse.die
    assert_equal @person.spouses, @spouse
    assert_equal @person.spouses.married, nil
    assert_equal @spouse.spouses, @person
    assert_equal @spouse.spouses.married, nil
    @person << @secondspouse
    assert_equal @person.spouses.married, nil
    @person.marry(@secondspouse)
    assert @person.valid?
    assert_equal @person.spouses.married, @secondspouse
    assert_equal @spouse.spouses, @person
    assert_equal @secondspouse.spouses.married, @person
  end

  test "cannot have more than one current spouse" do
    @person.marry(@spouse)
    assert_raise { @person.marry(@secondspouse) }
    assert_raise { @spouse.marry(@secondspouse) }
    assert_equal @person.spouses, @spouse
    assert_eqaul @spouse.spouses, @person
  end

  test "can have former spouse and current spouse" do
    @person.spouses << @spouse
    @person.marry(@secondspouse)
    assert @person.valid?
    assert_equal @person.spouses.married, @secondspouse
    assert_eqaul @person.spouses.count, 2
    assert_equal @spouse.spouses.married, @person
    assert_equal @spouse.spouses.count, 1
    assert_equal @secondspouse.spouses.count, 1
  end

  test "can have former spouse thorugh death" do
    @person.marry(@secondspouse)
    @secondspouse.die
    assert_equal @person.spouses.married, nil
    assert_equal @seconspouse.spouses.married, nil
    assert_equal @person.spouses.all, @secondspouse
    assert_equal @secondspouse.spouses.all, @person
  end

  test "can create former spouses through divorce" do
    @person.marry(@spouse)
    assert_equal @person.spouses.married, @spouse
    assert_equal @spouse.spouses.married, @person
    @person.divorce(@spouse)
    assert_equal @person.spouses.married, nil
    assert_eqaul @spouse.spouses.married, nil
    assert_equal @person.spouses.all, @spouse
    assert_equal @spouse.spouses.all, @person
  end
end