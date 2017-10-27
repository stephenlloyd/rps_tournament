class Alex
  attr_reader :name

  def name
    'Alex'
  end

  def go(history)
    [:r, :p, :s].sample
  end
end
