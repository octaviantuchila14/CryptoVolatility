class ExchangeDataController < ApplicationController
  before_action :set_exchange_datum, only: [:show, :edit, :update, :destroy]

  # GET /exchange_data
  # GET /exchange_data.json
  def index
    @exchange_data = ExchangeDatum.all
  end

  # GET /exchange_data/1
  # GET /exchange_data/1.json
  def show
  end

  # GET /exchange_data/new
  def new
    @exchange_datum = ExchangeDatum.new
  end

  # GET /exchange_data/1/edit
  def edit
  end

  # POST /exchange_data
  # POST /exchange_data.json
  def create
    @exchange_datum = ExchangeDatum.new(exchange_datum_params)

    respond_to do |format|
      if @exchange_datum.save
        format.html { redirect_to @exchange_datum, notice: 'Exchange datum was successfully created.' }
        format.json { render :show, status: :created, location: @exchange_datum }
      else
        format.html { render :new }
        format.json { render json: @exchange_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exchange_data/1
  # PATCH/PUT /exchange_data/1.json
  def update
    respond_to do |format|
      if @exchange_datum.update(exchange_datum_params)
        format.html { redirect_to @exchange_datum, notice: 'Exchange datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @exchange_datum }
      else
        format.html { render :edit }
        format.json { render json: @exchange_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exchange_data/1
  # DELETE /exchange_data/1.json
  def destroy
    @exchange_datum.destroy
    respond_to do |format|
      format.html { redirect_to exchange_data_url, notice: 'Exchange datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exchange_datum
      @exchange_datum = ExchangeDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exchange_datum_params
      params.require(:exchange_datum).permit(:date, :price, :reference_currency)
    end
end
