class AddFieldsToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :creator_id, :integer
    add_column :games, :joiner_id, :integer
  end
end
