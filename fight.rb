require_relative './lib/tournament'

Dir['./bots/*.rb'].each { |f| require f }

bots = [David, Stephen, Isaac, Constant, Alex, MuyiwaBot, JadeBot, Pedro]

win_counts = Hash.new { |hash, key| hash[key] = 0 }

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

  win_counts[tournament.winner] += 1
  puts
end

puts
win_counts
  .to_a
  .sort_by { |(name, count)| -1 * count }
  .each_with_index { |(name, count), index| puts "#{index + 1}. #{name} won #{count} times" }
