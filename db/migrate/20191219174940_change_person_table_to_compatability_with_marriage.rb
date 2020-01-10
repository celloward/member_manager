class ChangePersonTableToCompatabilityWithMarriage < ActiveRecord::Migration[5.2]
  def change
    remove_reference :people, :spouse
    remove_reference :people, :former_spouse
    remove_column :people, :living
  end
end
