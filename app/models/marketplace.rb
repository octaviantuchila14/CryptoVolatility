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

    p "rates_x are #{rates_x}"
    p "rates_y are #{rates_y}"

    rates_x = rates_x.to_scale
    rates_y = rates_y.to_scale
    cov = Statsample::Bivariate.covariance(rates_x, rates_y)
    cov / (rates_x.standard_deviation_sample * rates_y.standard_deviation_sample)
  end


end
