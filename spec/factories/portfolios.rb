FactoryGirl.define do
  factory :portfolio do
    start_date Date.new(2015, 5, 10)
    end_date Date.new(2015, 5, 23)
    p_return 1.5
    variance 1.5
  end

end
