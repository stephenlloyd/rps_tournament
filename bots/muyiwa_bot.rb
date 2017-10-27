require 'byebug'

class MuyiwaBot
  def go(opponent_historic_moves)
    return [] if opponent_historic_moves.empty?

    # All one value
    only_one_type = opponent_historic_moves.uniq.one?
    if only_one_type
      decide_winner(opponent_historic_moves.first)
    else
      decide_winner(frequently_analyse(opponent_historic_moves))
    end
  end

  def name
    'Muyiwa'
  end

  private

  def frequently_analyse(opponent_historic_moves)
    rock_count = opponent_historic_moves.count(:r)
    paper_count = opponent_historic_moves.count(:p)
    scissor_count = opponent_historic_moves.count(:s)

    return :draw if rock_count == paper_count && scissor_count < rock_count || rock_count == scissor_count && paper_count <= rock_count || paper_count == scissor_count && rock_count <= paper_count
    frequency = opponent_historic_moves.inject(Hash.new(0)) do |h, v|
      h[v] += 1;
      h
    end
    most_values = opponent_historic_moves.max_by { |v| frequency[v] }
  end

  def decide_winner(value)
    random = [:r, :p, :s].sample
    case value
    when :r
      :p
    when :p
      :s
    when :s
      :r
    when :draw
      random
    else
      random
    end
  end
end
