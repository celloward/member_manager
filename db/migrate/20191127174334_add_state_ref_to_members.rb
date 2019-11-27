class AddStateRefToMembers < ActiveRecord::Migration[5.2]
  def change
    add_reference :members, :state, foreign_key: true
  end
end
