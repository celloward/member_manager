class RemoveStateReferenceFromPeople < ActiveRecord::Migration[5.2]
  def change
    remove_reference :people, :state, foreign_key: true
  end
end
