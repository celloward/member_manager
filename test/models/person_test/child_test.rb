require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  
  setup do
    @child = Person.create(first_name: "Junior", last_name: "Person", sex: "female")
    @child2 = Person.create(first_name: "The Second", last_name: "Person", sex: "male")
  end

  test "can have children" do
    @person.children << @child
    assert_equal @person.children.first, @child
    @person.children << @child2
    assert_equal @person.children.count, 2
    assert_equal @person.children.last, @child2
  end

  test "can have no children" do
    assert_empty @person.children
    assert @person.valid?
  end

  test "can have parent" do
    @person.children << @child
    assert_equal @child.parents.count, 1
    assert_equal @child.parents.first, @person
  end

  test "child can have multiple parents" do
    @person.children << @child
    @spouse.children << @child
    assert_equal @child.parents.count, 2
  end

  test "children get inherited through marriage" do
    @person.children << @child2
    @spouse.children << @child
    assert_equal @person.children.count, 1
    assert_equal @person.children.count, 1
    @person.marry(@spouse, "2020-02-01")
    assert_equal @spouse.children.count, 2
    assert_equal @person.children.count, 2
  end

  test "cannot have self as child" do
    @person.children << @person
    assert_not @person.valid?
  end

  test "cannot have same child multiple times" do
    @person.children << @child
    assert_raises { @person.children << @child }
  end
end