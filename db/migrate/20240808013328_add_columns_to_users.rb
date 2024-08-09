class AddColumnsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :creator_id, :integer
    add_column :users, :joiner_id, :integer
  end
end
