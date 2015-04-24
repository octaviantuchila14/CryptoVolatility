class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def load_csv_file
    #TODO do this only once, when the page is first loaded
    Dir.foreach(Rails.root.join('tmp', 'csvFiles').to_s) do |file|
      next if file.match(/\A(\.).*/)
      currency, ref_currency = file.match(/([a-zA-Z]{3})_([a-zA-Z]{3}).*/i).captures
      currency.downcase
      ref_currency.downcase
      #create currencies if they don't exist
      Currency.find_or_create_by(name: currency)
      Currency.find_or_create_by(name: ref_currency)

      #read exchange rates from file
      csv_data = SmarterCSV.process(Rails.root.join('tmp', 'csvFiles', file.to_s).to_s)
      csv_data.each do |entry|
        @exchange_rate = ExchangeRate.new
        @exchange_rate.date = entry[:DATE]
        @exchange_rate.time = entry[:TIME]
        @exchange_rate.last = entry[:LAST]
        @exchange_rate.high = entry[:HIGH]
        @exchange_rate.low = entry[:LOW]
        @exchange_rate.volume = entry[:VOLUME]
        @exchange_rate.save
      end
    end
  end

end
