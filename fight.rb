require_relative './lib/tournament'

Dir['./bots/*.rb'].each { |f| require f }

bots = [David, Stephen, Isaac, Constant, Alex, MuyiwaBot, JadeBot, Pedro]

bots.combination(2).each do |bot1, bot2|
  tournament = Tournament.new(bot1.new, bot2.new)
  puts "Playing #{bot1.new.name} against #{bot2.new.name}"
  begin
    tournament.fight(1000)
  rescue StandardError => error
    puts error.message
    puts error.backtrace
  end
  puts tournament.report
  puts
end
