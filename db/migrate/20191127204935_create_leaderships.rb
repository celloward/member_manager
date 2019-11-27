class CreateLeaderships < ActiveRecord::Migration[5.2]
  def change
    create_table :leaderships do |t|
      t.references :leader, references: :members, foreign_key: { to_table: :members }
      t.references :ministry, foreign_key: true
      t.timestamps
    end
  end
end
