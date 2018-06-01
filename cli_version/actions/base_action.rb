class BaseAction
  def load_security_data_for security_symbol
    YAML::load_file("../market_data/#{security_symbol}_jan_june_2017_data.yml")
  end
end
