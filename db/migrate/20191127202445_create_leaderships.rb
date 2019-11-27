class CreateLeaderships < ActiveRecord::Migration[5.2]
  def change
    create_table :leaderships do |t|
      t.references :ministries, foreign_key: true
      t.references :leaders, foreign_key: true

      t.timestamps
    end
  end
end
