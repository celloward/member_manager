class ChangeMembersToPeople < ActiveRecord::Migration[5.2]
  def change
    rename_table :members, :people
  end
end
