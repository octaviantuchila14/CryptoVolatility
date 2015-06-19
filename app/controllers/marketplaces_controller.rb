class MarketplacesController < ApplicationController
  before_action :set_marketplace, only: [:show, :edit, :update, :destroy]

  # GET /marketplaces
  # GET /marketplaces.json
  def index
    @marketplaces = Marketplace.all
  end

  # GET /marketplaces/1
  # GET /marketplaces/1.json
   def show
      @pred_currency = Currency.find_by(id: params[:currency_id])
      @correlations_hash = @marketplace.get_correlations(@pred_currency)
     @capm = @marketplace.ill_capm(@pred_currency)
  #   @capm_ers = @market.capm_prediction(@pred_currency)
  #   @ill_ers = @market.illiquidity_prediction(@pred_currency)
  end

  # GET /marketplaces/new
  def new
    @marketplace = Marketplace.new
  end

  # GET /marketplaces/1/edit
  def edit
  end

  # POST /marketplaces
  # POST /marketplaces.json
  def create
    @marketplace = Marketplace.new(marketplace_params)

    respond_to do |format|
      if @marketplace.save
        format.html { redirect_to @marketplace, notice: 'Marketplace was successfully created.' }
        format.json { render :show, status: :created, location: @marketplace }
      else
        format.html { render :new }
        format.json { render json: @marketplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marketplaces/1
  # PATCH/PUT /marketplaces/1.json
  def update
    respond_to do |format|
      if @marketplace.update(marketplace_params)
        format.html { redirect_to @marketplace, notice: 'Marketplace was successfully updated.' }
        format.json { render :show, status: :ok, location: @marketplace }
      else
        format.html { render :edit }
        format.json { render json: @marketplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marketplaces/1
  # DELETE /marketplaces/1.json
  def destroy
    @marketplace.destroy
    respond_to do |format|
      format.html { redirect_to marketplaces_url, notice: 'Marketplace was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marketplace
      @marketplace = Marketplace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def marketplace_params
      params[:marketplace]
    end
end
