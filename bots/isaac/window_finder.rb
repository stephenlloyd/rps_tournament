class Isaac
  class WindowFinder
    def self.find_window(history, length)
      return unless history.length > length
      last_window = history.last(length)
      other_windows = windows(history, length)
      matches = other_windows.select { |window| window.first(length) == last_window }

      [matches.count, matches.map(&:last)]
    end

    def self.windows(history, length)
      Range.new(0, history.length - length - 1).map do |start_index|
        history[Range.new(start_index, start_index + length)]
      end
    end
  end
end
