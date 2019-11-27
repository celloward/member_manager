class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :street_address
      t.string :city
      t.string :zipcode
      t.string :phone
      t.string :dob

      t.timestamps
    end
  end
end
