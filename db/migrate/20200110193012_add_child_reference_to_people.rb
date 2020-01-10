class AddChildReferenceToPeople < ActiveRecord::Migration[5.2]
  def change
    add_reference :people, :child
  end
end
