module Api
  module V0
    class MarketsController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

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
    
      private
    
      def not_found
        render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }, status: :not_found
      end
    end
  end
end
