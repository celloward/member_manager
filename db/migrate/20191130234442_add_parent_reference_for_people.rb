class AddParentReferenceForPeople < ActiveRecord::Migration[5.2]
  def change
    add_reference :people, :parent
  end
end
