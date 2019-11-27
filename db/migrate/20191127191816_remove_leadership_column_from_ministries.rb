class RemoveLeadershipColumnFromMinistries < ActiveRecord::Migration[5.2]
  def change
    remove_column :ministries, :leadership_id
  end
end
