class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.json :state, null: false
      t.string :current_symbol, null: false

      t.timestamps
    end
  end
end
