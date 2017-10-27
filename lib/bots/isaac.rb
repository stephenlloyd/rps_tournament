require_relative '../tournament'
require_relative 'window_finder'

module Bots
  class Isaac
    attr_reader :name

    def initialize(name = 'Isaac')
      @name = name
      @my_history = []
      @my_strategies = {
        shortest_consistent_window: Array.new(3) { 0 },
        longest_window: Array.new(3) { 0 },
        repeating_string: Array.new(3) { 0 },
        frequency: Array.new(3) { 0 },
        random: Array.new(3) { 0 }
      }
      @last_strategy = nil
      @last_bluff_count = nil
    end

    def go(their_history)
      check_last_move_outcome(their_history)
      @last_strategy, @last_bluff_count = choose_strategy(their_history)

      move = send(last_strategy, their_history)
      last_bluff_count.times { move = apply_bluff(move) }
      my_history << move

      move
    end

    private

    attr_reader :my_history, :my_strategies, :last_strategy, :last_bluff_count

    def choose_strategy(history)
      best_win_count = my_strategies.values.map(&:max).max
      my_strategies.flat_map do |strategy, counts|
        counts.each_with_index
          .select { |count, _| count == best_win_count }
          .map { |count, bc| [strategy, bc] }
      end.sample
    end

    def apply_bluff(move)
      RPS::RULES.fetch(move)
    end

    def shortest_consistent_window(history)
      _count, next_moves = (3..10).map { |length| WindowFinder.find_window(history, length) }
        .compact
        .select { |(count, _next_moves)| count > 0 }
        .select { |(_count, next_moves)| next_moves.uniq.count == 1 }
        .min_by(&:first)

      return random(history) unless next_moves && next_moves.any?

      predicted = next_moves.group_by(&:itself).max_by { |_, ms| ms.count }&.first
      return random(history) unless predicted
      beat_move(predicted)
    end

    def longest_window(history)
      _count, next_moves = (3..10).map { |length| WindowFinder.find_window(history, length) }
        .compact
        .select { |(count, _next_moves)| count > 0 }
        .max_by(&:first)

      return random(history) unless next_moves && next_moves.any?

      predicted = next_moves.group_by(&:itself).max_by { |_, ms| ms.count }&.first
      return random(history) unless predicted
      beat_move(predicted)
    end

    def repeating_string(history)
      string = %i[r r p s p p r s s]
      index = history.count % string.length
      string[index]
    end

    def frequency(history)
      return %i[r p s].sample if history.empty?
      counts = history.group_by(&:itself).map { |move, moves| [move, moves.count] }
      predicted = counts.map(&:reverse).max_by(&:first)[1]
      beat_move(predicted)
    end

    def beat_move(move)
      RPS::RULES.invert.fetch(move)
    end

    def random(_history)
      %i[r p s].sample
    end

    def my_history
      @my_history ||= []
    end

    def check_last_move_outcome(history)
      return unless last_strategy && last_bluff_count

      their_last_move = history.last
      my_last_move = my_history.last
      i_win, they_win = RPS.fight(my_last_move, their_last_move)
      if i_win == 1
        my_strategies[last_strategy][last_bluff_count] += 1
      elsif they_win == 1
        my_strategies[last_strategy][last_bluff_count] -= 1
      end
    end
  end
end
