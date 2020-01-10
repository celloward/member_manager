class AddDateOfDeathToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :date_of_death, :string, null: true
  end
end
