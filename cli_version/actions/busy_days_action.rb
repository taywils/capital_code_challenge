class BusyDaysAction < BaseAction
  def initialize
  end

  public

  def get_busy_days security_symbols
    nested_busy_days = []
    busy_days_output = {}

    security_symbols.each do |security_symbol|
      nested_busy_days << calculate_busy_days(security_symbol)
    end

    busy_days_output["busy-days"] = nested_busy_days.flatten
  end

  private

  def calculate_busy_days security_symbol
    security_data = load_security_data_for security_symbol

    volumes = []
    security_data.map { |data| volumes << data.volume }

    average_volume = volumes.sum / (volumes.size.to_f)
    ten_percent_higher_average_volume = average_volume * 1.1

    busy_days_data = security_data.select { |data| data.volume > ten_percent_higher_average_volume }

    output_data = []
    busy_days_data.each do |data|
      output_data << { ticker: security_symbol.upcase,
                       date: data.date.strftime("%Y-%m-%d"),
                       volume: data.volume,
                       average_volume: average_volume }

    end

    output_data
  end
end
