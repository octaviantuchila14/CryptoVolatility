FactoryGirl.define do
  factory :exchange_rate do
    subject 'btc'
    last 0
    ref_cr 'usd'
    time DateTime.now
  end
end