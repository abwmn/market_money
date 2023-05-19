class Api::V0::MarketVendorsController < ApplicationController
  def create
    market = Market.find(params[:market_id])
    vendor = Vendor.find(params[:vendor_id])
  
    market_vendor = MarketVendor.new(market: market, vendor: vendor)
  
    if market_vendor.save
      render json: { message: 'Successfully added vendor to market' }, status: :created
    else
      render json: { errors: market_vendor.errors.full_messages.map { |msg| { detail: msg } } }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { errors: [{ detail: "Validation failed: Market must exist or Vendor must exist" }] }, status: :not_found
  end
  

  private

  def market_vendor_params
    params.permit(:market_id, :vendor_id)
  end
end
