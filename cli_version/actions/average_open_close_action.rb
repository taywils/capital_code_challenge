class AverageOpenCloseAction < BaseAction
  def initialize
  end

  public

  def get_average_open_and_close security_symbols
    average_open_close_data = {}

    security_symbols.each do |security_symbol|
      average_open_close = calculate_average_open_close security_symbol
      average_open_close_data[security_symbol.upcase] = average_open_close[security_symbol.upcase]
    end

    average_open_close_data
  end

  private

  def calculate_average_open_close security_symbol
    security_symbol.downcase!

    security_data = load_security_data_for security_symbol

    output_data = {}
    output_data[security_symbol.upcase] = []

    (1..6).each do |month|
      monthly_security_data = security_data.select { |data| data.date.month == month } 

      month_string = monthly_security_data.first.date.strftime("%Y-%m")

      open_prices = []
      monthly_security_data.each { |data| open_prices << data.open }
      average_open = open_prices.sum / open_prices.size.to_f

      closing_prices = []
      monthly_security_data.each { |data| closing_prices << data.close }
      average_close = closing_prices.sum / closing_prices.size.to_f

      decimal_average_open = BigDecimal.new(average_open.to_s).truncate(2).to_s("F")
      decimal_average_close = "$" + BigDecimal.new(average_close.to_s).truncate(2).to_s("F")

      output_data[security_symbol.upcase] << { month: month_string,
                                               average_open: decimal_average_open,
                                               average_close: decimal_average_close }
    end

    output_data
  end
end
