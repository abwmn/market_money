class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    markets = MarketSerializer.new(Market.all).serialized_json
    render json: markets
  end  

  def show
    market = Market.find(params[:id])
    render json: MarketSerializer.new(market)
  end

  def vendors
    market = Market.find(params[:id])
    if market
      render json: VendorSerializer.new(market.vendors)
    else
      render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:market_id]}" }] }, status: :not_found
    end
  end

  def search
    if valid_parameters?
      @markets = Market.where(search_params)
      render json: { data: @markets }, status: :ok
    else
      render json: { errors: [{ detail: 'Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.' }] }, status: :unprocessable_entity
    end
  end

  def nearest_atm
    @market = Market.find(params[:id])

    atms = TomtomService.nearest_atm(@market.lat, @market.lon)

    render json: { data: atms }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }, status: :not_found
  end

  private
  
  def search_params
    params.permit(:state, :city, :name)
  end
  
  def valid_parameters?
    valid_param_sets = [
      %i[state],
      %i[state city],
      %i[state city name],
      %i[state name],
      %i[name]
    ]
    
    valid_param_sets.include?(search_params.keys.map(&:to_sym))
  end

  def record_not_found
    render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }, status: :not_found
  end
end