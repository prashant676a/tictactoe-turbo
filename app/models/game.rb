class Game < ApplicationRecord

  belongs_to :creator, class_name: 'User', optional: true
  belongs_to :joiner, class_name: 'User', optional: true
  
  after_create { update(slug: Digest::SHA2.hexdigest(id.to_s)) }

  def to_param
    self.slug.to_s
  end



  before_validation(on: :create) do
    self.state = initial_state
  end


  def move!(row, col)
    self.state[row.to_s][col.to_s] = current_symbol

    self.current_symbol = current_symbol == "X" ? "O" : "X"

    if winner 
      self.finished = true
    end

    self.save!

  end

  def winner

    winning_combinations = [
      [[0, 0], [0, 1], [0, 2]], 
      [[1, 0], [1, 1], [1, 2]], 
      [[2, 0], [2, 1], [2, 2]], 
      [[0, 0], [1, 0], [2, 0]], 
      [[0, 1], [1, 1], [2, 1]], 
      [[0, 2], [1, 2], [2, 2]], 
      [[0, 0], [1, 1], [2, 2]], 
      [[0, 2], [1, 1], [2, 0]]  
    ]
  
    winning_combinations.each do |combination|
      symbols = combination.map { |row, col| state[row.to_s][col.to_s] }
      return symbols.first if symbols.uniq.size == 1 && symbols.first.present?
    end
  
    nil
  end

  def reset
    self.state = initial_state
    self.current_symbol = creator_symbol
    self.finished = false 
    self.save!
  end

  def initial_state
    {
      0 => { 0 => nil, 1 => nil, 2 => nil },
      1 => { 0 => nil, 1 => nil, 2 => nil },
      2 => { 0 => nil, 1 => nil, 2 => nil }
    }
  end

end
