class AddGenderColumnToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :gender, :string
  end
end
