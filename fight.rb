require_relative './lib/tournament'

Dir['./bots/*.rb'].each { |f| require f }

bots = [David, Stephen, Isaac, Constant]

bots.combination(2).each do |bot1, bot2|
  tournament = Tournament.new(bot1.new, bot2.new)
  tournament.fight(1000)
  puts tournament.report
  puts
end
