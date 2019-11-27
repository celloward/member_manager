class CreateMinistries < ActiveRecord::Migration[5.2]
  def change
    create_table :ministries do |t|
      t.string :name
      t.references :leadership, foreign_key: true

      t.timestamps
    end
  end
end
