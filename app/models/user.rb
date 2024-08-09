class User < ApplicationRecord
  has_many :games_as_creator, class_name: 'Game', foreign_key: 'creator_id'
  has_many :games_as_player, class_name: 'Game', foreign_key: 'player_id'
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
end
