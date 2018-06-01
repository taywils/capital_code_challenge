require 'sinatra'
require 'quandl'

require 'json'
require 'yaml'

require_relative '../cli_version/app'

data_dir_name = "market_data"
security_symbols = %w[GOOGL MSFT COF]

if !File.directory?("../#{data_dir_name}")
  puts "ERROR: \"../#{data_dir_name}\" directory not found."
  puts "Run the \"seed\" command from the \"cli_version\" main.rb to generate \"#{data_dir_name}\""
  return
end

app = App.new

foo_bar_cache = {}

get '/monthly-average' do
  unless foo_bar_cache.keys.include? 'monthly-average'
    foo_bar_cache['monthly-average'] = app.get_average_open_and_close security_symbols
  end

  JSON.generate(foo_bar_cache['monthly-average'])
end

get '/max-daily-profit' do
  unless foo_bar_cache.keys.include? 'max-daily-profit'
    foo_bar_cache['max-daily-profit'] = app.get_max_daily_profits security_symbols
  end

  JSON.generate(foo_bar_cache['max-daily-profit'])
end

get '/busy-day' do
  unless foo_bar_cache.keys.include? 'busy-day'
    foo_bar_cache['busy-day'] = app.get_busy_days security_symbols
  end

  JSON.generate(foo_bar_cache['busy-day'])
end

get '/biggest-loser' do
  unless foo_bar_cache.keys.include? 'biggest-loser'
    foo_bar_cache['biggest-loser'] = app.get_losing_days security_symbols
  end

  JSON.generate(foo_bar_cache['biggest-loser'])
end

get '/*' do
  JSON.generate({ error: "Route not found" })
end
