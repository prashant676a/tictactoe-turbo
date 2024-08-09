class AddPlayerSymbolsToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :joiner_symbol, :string
    add_column :games, :creator_symbol, :string
  end
end
