class AddStatusToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :status, :string, default: 'waiting'
  end
end
