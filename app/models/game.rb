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

    if winner 
      self.finished = true
    end

    self.save!

  end

  def winner
    # Check rows, columns, and diagonals for a win
    winning_combinations = [
      [[0, 0], [0, 1], [0, 2]], # Row 1
      [[1, 0], [1, 1], [1, 2]], # Row 2
      [[2, 0], [2, 1], [2, 2]], # Row 3
      [[0, 0], [1, 0], [2, 0]], # Column 1
      [[0, 1], [1, 1], [2, 1]], # Column 2
      [[0, 2], [1, 2], [2, 2]], # Column 3
      [[0, 0], [1, 1], [2, 2]], # Diagonal \
      [[0, 2], [1, 1], [2, 0]]  # Diagonal /
    ]
  
    winning_combinations.each do |combination|
      symbols = combination.map { |row, col| state[row.to_s][col.to_s] }
      return symbols.first if symbols.uniq.size == 1 && symbols.first.present?
    end
  
    nil
  end

  after_update_commit -> {broadcast_replace_later_to "games", locals: {game: self, user:Current.user == self.creator ? self.joiner : self.creator}}
  
end
