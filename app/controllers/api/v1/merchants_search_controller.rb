class Api::V1::MerchantsSearchController < ApplicationController
  def show
    if !params[:name].nil? && params[:name] != ""
      merchant = Merchant.find_merchant_by_name(params[:name])
      if merchant == nil
        render json: ErrorSerializer.query_error, status: 400
      else
        render json: MerchantSerializer.new(merchant)
      end
    else
      render json: ErrorSerializer.query_error, status: 400
    end
  end
end