require 'test_helper'

class ExchangeDataControllerTest < ActionController::TestCase
  setup do
    @exchange_datum = exchange_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exchange_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exchange_datum" do
    assert_difference('ExchangeDatum.count') do
      post :create, exchange_datum: { date: @exchange_datum.date, price: @exchange_datum.price, reference_currency: @exchange_datum.reference_currency }
    end

    assert_redirected_to exchange_datum_path(assigns(:exchange_datum))
  end

  test "should show exchange_datum" do
    get :show, id: @exchange_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exchange_datum
    assert_response :success
  end

  test "should update exchange_datum" do
    patch :update, id: @exchange_datum, exchange_datum: { date: @exchange_datum.date, price: @exchange_datum.price, reference_currency: @exchange_datum.reference_currency }
    assert_redirected_to exchange_datum_path(assigns(:exchange_datum))
  end

  test "should destroy exchange_datum" do
    assert_difference('ExchangeDatum.count', -1) do
      delete :destroy, id: @exchange_datum
    end

    assert_redirected_to exchange_data_path
  end
end
