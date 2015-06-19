class Marketplace < ActiveRecord::Base
  has_many :currencies

  def get_correlations(pred_currency)
    selected_cr = {}
    self.currencies.each do |currency|
      if(currency != pred_currency)
        correlation = asset_correlation(pred_currency, currency)
        # if(correlation < LOW_CORRELATION)
          selected_cr[currency.full_name] = correlation
        # end
      end
    end
    selected_cr
  end


  def asset_correlation(x, y)
    rs_x = x.last_month
    rs_y = y.last_month
    rates_x, rates_y = [], []

    rs_x.each do |r_x|
      r_y = rs_y.select{|er| er[:date] == r_x[:date]}.first
      if(r_y != nil)
        rates_x << r_x[:return]
        rates_y << r_y[:return]
      end
    end

    rates_x = rates_x.to_scale
    rates_y = rates_y.to_scale
    cov = Statsample::Bivariate.covariance(rates_x, rates_y)
    cov / (rates_x.standard_deviation_sample * rates_y.standard_deviation_sample)
  end

  def market_connection(x)
    rs_c = x.last_month
    rs_m = compute_market

    capm_data = {}
    capm_data[:beta] = Statsample::Bivariate.covariance(rs_c.map{|r| r[:return]}.to_scale, rs_m.map{|r| r[:return]}.to_scale)/(rs_m.map{|r| r[:return]}.to_scale.variance_sample)
    capm_data[:expected_return] = 0.000021 + capm_data[:beta]*(rs_m.last[:return] - 0.000021)
    capm_data[:actual_return] = rs_c.last[:return]

    capm_data
  end

  def compute_market
    cr1 = Currency.where(full_name: "Bitcoin").first.last_month
    cr2 = Currency.where(full_name: "Litecoin").first.last_month
    cr3 = Currency.where(full_name: "Peercoin").first.last_month

    cr1.each do |day_val|
      r2 = cr2.select{|er| er[:date] == day_val[:date]}.first
      r3 = cr3.select{|er| er[:date] == day_val[:date]}.first
      day_val[:return] = 0.95*day_val[:return] + 0.3*r2[:return] + 0.2*r3[:return]
    end

    cr1
  end

  def ill_capm(x)
    capm_data = market_connection(x)
    ret = x.last_month.last
    capm_data[:ill_expected] = 0.7 * capm_data[:expected_return] + 0.3 * ret[:return]
    capm_data
  end


end
