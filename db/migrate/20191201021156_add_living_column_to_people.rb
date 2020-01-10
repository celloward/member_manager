class AddLivingColumnToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :living, :boolean, null: false, default: true
  end
end
