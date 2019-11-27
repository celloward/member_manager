require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  setup do
    ["a".."g"].each do |name|
      Member.create(first_name: name, email: "#{name}@gmail.com")
    end
  end

  test "members can lead a ministry" do
    worship = Ministry.create(name: "Worship")
    worship.leader = Member.find_by(first_name: "c")
    assert worship.leader
    assert_not_equal worship.leader, Member.find_by(first_name: "b")
  end

end
