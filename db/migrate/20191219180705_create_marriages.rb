class CreateMarriages < ActiveRecord::Migration[5.2]
  def change
    create_table :marriages do |t|
      t.references :husband, foreign_key: true
      t.references :wife, foreign_key: true
      t.string :marriage_date
      t.string :end_date

      t.timestamps
    end
  end
end
