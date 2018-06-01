require_relative './actions/base_action'
require_relative './actions/average_open_close_action'
require_relative './actions/busy_days_action'
require_relative './actions/losing_days_action'
require_relative './actions/max_daily_profits_action'

class App
  attr_reader :average_open_close_action, :busy_days_action
  attr_reader :losing_days_action, :max_daily_profits_action

  def initialize
    @average_open_close_action = AverageOpenCloseAction.new
    @busy_days_action = BusyDaysAction.new
    @losing_days_action = LosingDaysAction.new
    @max_daily_profits_action = MaxDailyProfitsAction.new
  end

  public

  def get_average_open_and_close security_symbols
    @average_open_close_action.get_average_open_and_close security_symbols
  end

  def get_losing_days security_symbols
    @losing_days_action.get_losing_days security_symbols
  end

  def get_busy_days security_symbols
    @busy_days_action.get_busy_days security_symbols
  end

  def get_max_daily_profits security_symbols
    @max_daily_profits_action.get_max_daily_profits security_symbols
  end
end
