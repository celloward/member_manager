class AddSexColumnToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :sex, :string
  end
end
