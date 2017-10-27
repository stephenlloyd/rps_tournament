require 'csv'

class RPS
  RULES = {r: :s, p: :r, s: :p}
  def self.fight(a,b)
    return [0,0] if a == b
    RULES[a] == b ? [1, 0] : [0, 1]
  end
end

class Tournament
  attr_reader :bot1, :bot2, :bot_1_wins, :bot_2_wins
  def initialize(bot1, bot2)
    @bot1 = bot1
    @bot2 = bot2
    @bot_1_wins = 0
    @bot_2_wins = 0
    @bot_1_history = []
    @bot_2_history = []
  end

  def ready?
    bot1.respond_to?(:go) && bot2.respond_to?(:go)
  end

  def report
    body = [bot1.name,bot2.name,bot_1_wins,bot_2_wins,winner].to_csv
  end

  def winner
    return '-' if  bot_1_wins == bot_2_wins
    bot_1_wins > bot_2_wins ? bot1.name : bot2.name
  end

  def fight(rounds = 100)
    rounds.times do
      bot1_go = bot1.go(@bot_2_history)
      bot2_go = bot2.go(@bot_1_history)
      score = RPS.fight(bot1_go, bot2_go)
      @bot_1_history << bot1_go
      @bot_2_history << bot2_go
      @bot_1_wins += score[0]
      @bot_2_wins += score[1]
    end
  end
end

Dir['./bots/*.rb'].each { |f| require f}
