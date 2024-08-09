class RemoveFieldsFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :creator_id
    remove_column :users, :joiner_id
  end
end
