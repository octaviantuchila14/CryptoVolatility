class NeuralNetworksController < ApplicationController
  before_action :set_neural_network, only: [:show, :edit, :update, :destroy]

  # GET /neural_networks
  # GET /neural_networks.json
  def index
    @neural_networks = NeuralNetwork.all
  end

  # GET /neural_networks/1
  # GET /neural_networks/1.json
  def show
    @pred_currency = Currency.find_by(id: params[:currency_id])
    @nn_ers = @neural_network.backpropagation_predictions(@pred_currency)
  end

  # GET /neural_networks/new
  def new
    @neural_network = NeuralNetwork.new
  end

  # GET /neural_networks/1/edit
  def edit
  end

  # POST /neural_networks
  # POST /neural_networks.json
  def create
    @neural_network = NeuralNetwork.new(neural_network_params)

    respond_to do |format|
      if @neural_network.save
        format.html { redirect_to @neural_network, notice: 'Neural network was successfully created.' }
        format.json { render :show, status: :created, location: @neural_network }
      else
        format.html { render :new }
        format.json { render json: @neural_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /neural_networks/1
  # PATCH/PUT /neural_networks/1.json
  def update
    respond_to do |format|
      if @neural_network.update(neural_network_params)
        format.html { redirect_to @neural_network, notice: 'Neural network was successfully updated.' }
        format.json { render :show, status: :ok, location: @neural_network }
      else
        format.html { render :edit }
        format.json { render json: @neural_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /neural_networks/1
  # DELETE /neural_networks/1.json
  def destroy
    @neural_network.destroy
    respond_to do |format|
      format.html { redirect_to neural_networks_url, notice: 'Neural network was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_neural_network
      @neural_network = NeuralNetwork.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def neural_network_params
      params[:neural_network]
    end
end
