class Pedro
  def name
    self.class.name
  end

  def invert(hand)
    case hand
    when :r then :p
    when :p then :s
    when :s then :r
    end
  end

  def look_for_pattern(history)
    return nil if history.empty?
    r_history = history.reverse
    (3..20).to_a.reverse.each do |n|
      last_n = r_history.take(n).join
      index = r_history.drop(n).join.index(last_n)
      if r_history.empty? or index.nil?
        next
      end
      return invert r_history[n + index - 1]&.to_sym
    end
    return nil
  end

  def go(history)
    hand = look_for_pattern(history)
    if hand.nil?
      return %i[r p s].sample
    end
    hand
  end
end
