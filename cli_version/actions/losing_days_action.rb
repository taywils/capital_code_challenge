class LosingDaysAction < BaseAction
  def initialize
  end

  public

  def get_losing_days security_symbols
    losing_days_hash = {}

    security_symbols.each do |security_symbol|
      losing_days = calculate_losing_days security_symbol
      losing_days_hash[security_symbol.upcase] = losing_days[security_symbol.upcase].size
    end

    if losing_days_hash.empty?
      return { info: "No losing days, all securities were gaining" }
    end

    biggest_loser = losing_days_hash.sort_by { |security_symbol, total_losing_days| total_losing_days }.reverse.first
    biggest_loser_symbol = biggest_loser[0]
    biggest_loser_total_days = biggest_loser[1]

    { "biggest-loser": { "ticker": biggest_loser_symbol,
                         "total_days_loss": biggest_loser_total_days } }
  end

  private

  def calculate_losing_days security_symbol
    output_data = {}
    output_data[security_symbol.upcase] = []

    security_data = load_security_data_for security_symbol

    security_data.each do |data|
      if data.close < data.open
        day_string = data.date.strftime("%Y-%m-%d")
        open_close_delta = data.open - data.close

        output_data[security_symbol.upcase] << { date: day_string,
                                                 open_close_delta: open_close_delta }

      end
    end

    output_data
  end
end
