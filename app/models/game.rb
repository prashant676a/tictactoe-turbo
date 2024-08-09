class Game < ApplicationRecord

  belongs_to :creator, class_name: 'User', optional: true
  belongs_to :joiner, class_name: 'User', optional: true
  
  before_validation(on: :create) do
    self.state = {
      0 => { 0 => nil, 1 => nil, 2 => nil },
      1 => { 0 => nil, 1 => nil, 2 => nil },
      2 => { 0 => nil, 1 => nil, 2 => nil }
    }


  end


  def move!(row, col)
    self.state[row.to_s][col.to_s] = current_symbol

    #swap
    self.current_symbol = current_symbol == "X" ? "O" : "X"
    self.save!

  end

  after_update_commit -> {broadcast_replace_later_to "games", locals: {game: self, user:Current.user == self.creator ? self.joiner : self.creator}}
  
end
