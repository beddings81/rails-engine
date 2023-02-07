class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all

    if !merchants.empty?
      render json: MerchantSerializer.new(merchants)
    else
      render json: { "message": "The query could not be completed", :errors => ["There are no merchants in the database"]}, status: 404
    end
  end

  def show
    if Merchant.exists?(params[:id])
      merchant = Merchant.find(params[:id])
      render json: MerchantSerializer.new(merchant)
    else
      render json: { "message": "The query could not be completed", :errors => ["Merchant does not exist"] }, status: 404
    end
  end
end
