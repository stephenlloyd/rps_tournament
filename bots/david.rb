class David
  def initialize
    @opponent_moves = []
    @my_moves = []
    @opponent_victories = 0
    @my_victories = 0
    @net_win_rate = 0
    @winning_moves = {
      :r => :p,
      :p => :s,
      :s => :r
    }
    @rounds = 0

  end

  def go(opponent_moves)
    @opponent_moves = opponent_moves

    calculate_net_win_rate

    my_move =
    if @rounds == 0 || (@rounds > 100 && @net_win_rate.abs > 3.0)
      use_random_strategy
    else
      use_statistical_strategy
    end

    @my_moves << my_move

    my_move
  end

  def name
    "David BOT"
  end

  private

  def calculate_net_win_rate
    @opponent_moves.each_with_index do |opponent_move, i|
      my_move = @my_moves[i]
      if @winning_moves[my_move] == opponent_move
        @opponent_victories += 1
      elsif @winning_moves[opponent_move] == my_move
        @my_victories += 1
      end
    end

    @rounds = @opponent_moves.size.to_f

    @net_win_rate = (@my_victories / @rounds) - (@opponent_victories / @rounds)
  end

  def use_statistical_strategy
    opponent_moves = @opponent_moves

    times_to_shuffle = rand(10)

    times_to_shuffle.times do
      opponent_moves = opponent_moves.shuffle
    end

    @winning_moves[opponent_moves.first]
  end

  def use_random_strategy
    [:r, :p, :s].sample
  end
end
