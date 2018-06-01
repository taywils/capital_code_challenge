class MarketFetcher
  attr_reader :quandl_api_key

  def initialize(api_key)
    @quandl_api_key = api_key
  end

  def fetch_quandl_wiki_data_then_save_to_yaml_files
    Quandl::ApiConfig.api_key = @quandl_api_key
    Quandl::ApiConfig.api_version = '2015-04-09'

    security_symbols = %w[COF GOOGL MSFT]
    year = 2017
    end_month = 7

    puts "Fetching Quandl WIKI daily stock prices for stocks: #{security_symbols.join(', ')}\n\n"

    security_symbols.each do |security_symbol|
      print "Now fetching #{security_symbol}. Please wait... "

      # Fetch the security's data from Quandl
      security_data = Quandl::Dataset.get("WIKI/#{security_symbol}").data

      print "DONE!\nParsing #{security_symbol} data for Jan 2017 through Jun 2017. Please wait... "

      # Filter the security data by date between Jan 1 until end_month
      jan_june_security_data = security_data.select { |data_point|
        data_point.date.year == year and data_point.date.month < end_month }.reverse

      print "DONE!\nNow Saving to \"../market_data/#{security_symbol.downcase}_jan_june_2017_data.yml\" "

      # Export the security data to yaml formatted file
      File.open("../market_data/#{security_symbol.downcase}_jan_june_2017_data.yml", 'w') { |new_file|
        new_file.write jan_june_security_data.to_yaml }

      print "DONE!\n\n"
    end
  end
end
