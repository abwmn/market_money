class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def index
    @market = Market.find(params[:market_id])
    @vendors = @market.vendors
    render json: VendorSerializer.new(@vendors).serialized_json
  end

  def show
    @vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(@vendor).serialized_json
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: VendorSerializer.new(vendor).serialized_json, status: :created
    else
      raise ActiveRecord::RecordInvalid.new(vendor)
    end
  end

  def update
    @vendor = Vendor.find(params[:id])
    @vendor.update!(vendor_params)
    render json: VendorSerializer.new(@vendor).serialized_json
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.destroy
  end
  
  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def record_not_found(exception)
    error = ErrorMember.new(exception)
    render json: ErrorSerializer.new(error).serialized_json, status: error.code
  end

  def record_invalid(exception)
    error = ErrorMember.new(exception)
    render json: ErrorSerializer.new(error).serialized_json, status: error.code
  end  
end
