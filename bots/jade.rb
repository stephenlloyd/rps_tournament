class JadeBot

  def name
    "Jade's bot"
  end

  def go(their_move_history)
    if their_move_history.empty?
      return [:r, :p, :s].sample
    end
    case their_move_history.last
    when :r
      then :p
    when :s
      then :r
    when :p
      then :s
    end
  end
end
