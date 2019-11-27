class AddForeignKeysToLeaderships < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :leaderships, :ministries, 
    add_foreign_key :leaderships, :leaders, :bigint 
    add_index :leaderships, :ministries_id
    add_index :leaderships, leaders_id
  end
end
