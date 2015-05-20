namespace :download_csv do
  require 'mechanize'

  task get_files: :environment do
    mechanize = Mechanize.new
    mechanize.pluggable_parser.default = Mechanize::Download

    page = mechanize.get('http://alt19.com/')

    puts page.uri

    form = page.forms.first

    form.radiobuttons_with(name: 'presence')[0].check
    form.source = "btce"
    form.label = "BTC/USD"
    form.period = "1d"

    mechanize.get_file(form.submit).save!('alt19.csv')
    #p mechanize.get(form.submit)


    #file = mechanize.submit(form)
    #p file



  end
end