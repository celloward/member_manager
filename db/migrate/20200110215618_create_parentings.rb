class CreateParentings < ActiveRecord::Migration[5.2]
  def change
    create_table :parentings do |t|
      t.references :child
      t.references :parent
      t.timestamps
    end
    add_foreign_key :parentings, :user, on_delete: :cascade
    add_index :parentings, [ :child_id, :parent_id ], unique: true, name: "by_child_and_parent"
  end
end
