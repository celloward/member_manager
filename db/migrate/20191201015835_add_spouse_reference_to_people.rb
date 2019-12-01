class AddSpouseReferenceToPeople < ActiveRecord::Migration[5.2]
  def change
    add_reference :people, :spouse, index: true
  end
end
