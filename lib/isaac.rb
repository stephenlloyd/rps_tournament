require_relative 'tournament'
require_relative 'window_finder'

class Isaac
  attr_reader :name

  def initialize(name = 'Isaac')
    @name = name
    @my_history = []
    @my_strategies = {
      shortest_consistent_window: 0,
      longest_window: 0,
      repeating_string: 0,
      frequency: 0,
      random: 0
    }
    @last_strategy = nil
  end

  def go(their_history)
    check_last_move_outcome(their_history)
    @last_strategy = choose_strategy(their_history)

    send(last_strategy, their_history).tap do |move|
      my_history << move
    end
  end

  private

  attr_reader :my_history, :my_strategies, :last_strategy

  def choose_strategy(history)
    best_win_count = my_strategies.values.max
    my_strategies
      .select { |_, count| count == best_win_count }
      .map(&:first)
      .sample
  end

  def shortest_consistent_window(history)
    _count, next_moves = (3..10).map { |length| WindowFinder.find_window(history, length) }
      .compact
      .select { |(count, _next_moves)| count > 0 }
      .select { |(_count, next_moves)| next_moves.uniq.count == 1 }
      .min_by(&:first)

    return random(history) unless next_moves && next_moves.any?

    next_moves.group_by(&:itself).max_by { |_, ms| ms.count }&.first || random(history)
  end

  def longest_window(history)
    _count, next_moves = (3..10).map { |length| WindowFinder.find_window(history, length) }
      .compact
      .select { |(count, _next_moves)| count > 0 }
      .max_by(&:first)

    return random(history) unless next_moves && next_moves.any?

    next_moves.group_by(&:itself).max_by { |_, ms| ms.count }&.first || random(history)
  end

  def repeating_string(history)
    string = %i[r r p s p p r s s]
    index = history.count % string.length
    string[index]
  end

  def frequency(history)
    return %i[r p s].sample if history.empty?
    counts = history.group_by(&:itself).map { |move, moves| [move, moves.count] }
    counts.map(&:reverse).max_by(&:first)[1]
  end

  def random(_history)
    %i[r p s].sample
  end

  def my_history
    @my_history ||= []
  end

  def check_last_move_outcome(history)
    return unless last_strategy

    their_last_move = history.last
    my_last_move = my_history.last
    i_win, they_win = RPS.fight(my_last_move, their_last_move)
    if i_win == 1
      my_strategies[last_strategy] += 1
    elsif they_win == 1
      my_strategies[last_strategy] -= 1
    end
  end
end
