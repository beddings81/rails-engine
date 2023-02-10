class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    if !merchants.empty?
      render json: MerchantSerializer.new(merchants)
    else
      render json: ErrorSerializer.empty_database_error, status: 404
    end
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end
end
