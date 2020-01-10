class CreateMarriages < ActiveRecord::Migration[5.2]
  def change
    create_table :marriages do |t|
      t.references :husband
      t.references :wife
      t.string :marriage_date
      t.string :end_date

      t.timestamps
    end
    add_foreign_key :marriages, :user, on_delete: :cascade
  end
end
