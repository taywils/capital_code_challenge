class MaxDailyProfitsAction < BaseAction
  def initialize
  end

  public

  def get_max_daily_profits security_symbols
    max_daily_profits_hash = {}
    max_daily_profits_hash["max-daily-profits"] = []

    security_symbols.each do |security_symbol|
      max_daily_profit_for_security = calculate_max_daily_profits(security_symbol)
      max_daily_profits_hash["max-daily-profits"] << max_daily_profit_for_security[security_symbol.upcase]
    end

    max_daily_profits_hash
  end

  private

  def calculate_max_daily_profits security_symbol
    security_data = load_security_data_for security_symbol

    current_high_daily_profit = 0
    current_high_daily_profit_data = nil

    output_data = {}
    security_data.each do |data|
      daily_profit = data.high - data.low

      if daily_profit >= current_high_daily_profit or current_high_daily_profit.nil?
        current_high_daily_profit = daily_profit
        current_high_daily_profit_data = data
      end
    end

    pretty_print_profit = "$" + BigDecimal.new(current_high_daily_profit.to_s).truncate(2).to_s("F")

    output_data[security_symbol.upcase] = { ticker: security_symbol.upcase,
                                            date: current_high_daily_profit_data.date.strftime("%Y-%m-%d"),
                                            profit: pretty_print_profit }

    output_data
  end
end
