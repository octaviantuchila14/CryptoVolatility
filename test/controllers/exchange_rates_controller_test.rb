require 'test_helper'

class ExchangeRatesControllerTest < ActionController::TestCase
  setup do
    @exchange_rate = exchange_rates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exchange_rates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exchange_rate" do
    assert_difference('ExchangeRate.count') do
      post :create, exchange_rate: { date: @exchange_rate.date, high: @exchange_rate.high, last: @exchange_rate.last, low: @exchange_rate.low, time: @exchange_rate.time, volume: @exchange_rate.volume }
    end

    assert_redirected_to exchange_rate_path(assigns(:exchange_rate))
  end

  test "should show exchange_rate" do
    get :show, id: @exchange_rate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exchange_rate
    assert_response :success
  end

  test "should update exchange_rate" do
    patch :update, id: @exchange_rate, exchange_rate: { date: @exchange_rate.date, high: @exchange_rate.high, last: @exchange_rate.last, low: @exchange_rate.low, time: @exchange_rate.time, volume: @exchange_rate.volume }
    assert_redirected_to exchange_rate_path(assigns(:exchange_rate))
  end

  test "should destroy exchange_rate" do
    assert_difference('ExchangeRate.count', -1) do
      delete :destroy, id: @exchange_rate
    end

    assert_redirected_to exchange_rates_path
  end
end
