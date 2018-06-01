require 'main'
require 'quandl'
require 'yaml'

require_relative './market_fetcher'
require_relative './app'

Main {
  mode 'seed' do
    keyword('apikey') {
      required
      arity 1
      cast :string
      defaults ""
      description 'Valid Quandl WIKI Stock Price API Key'
    }

    def run
      if params['apikey'].given?
        puts "Seeding Market Data from Quandl."
        market_fetcher = MarketFetcher.new(params['apikey'].value)
        market_fetcher.fetch_quandl_wiki_data_then_save_to_yaml_files
      else
        puts "ERROR: \"apikey=\" terminal parameter is missing or empty"
      end
    end
  end

  option('action', 'a') {
    argument :optional
    arity 1
    cast :string
    defaults "monthly-average"
    description '[monthly-average, max-daily-profit, busy-day, biggest-loser]'
  }

  def run
    data_dir_name = "market_data"
    actions = %w[monthly-average max-daily-profit busy-day biggest-loser]
    security_symbols = %w[GOOGL MSFT COF]

    action = params['action'].value.downcase

    if !File.directory?("../#{data_dir_name}")
      puts "ERROR: \"../#{data_dir_name}\" directory not found."
      puts "Run the \"seed\" command to generate \"#{data_dir_name}\""
      return
    end

    if actions.include? action
      app = App.new

      case action
      when 'monthly-average'
        open_and_close_data = app.get_average_open_and_close security_symbols
        puts JSON.generate(open_and_close_data)
      when 'max-daily-profit'
        max_daily_profit_data = app.get_max_daily_profits security_symbols
        puts JSON.generate(max_daily_profit_data)
      when 'busy-day'
        busy_days_data = app.get_busy_days security_symbols
        puts JSON.generate(busy_days_data)
      when 'biggest-loser'
        biggest_loser_data = app.get_losing_days security_symbols
        puts JSON.generate(biggest_loser_data)
      end
    else
      puts "ERROR: Unknown action \"#{action}\" please choose from \"#{actions.join(', ')}\""
    end
  end
}
