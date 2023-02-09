class Api::V1::MerchantsSearchController < ApplicationController
  def show
    if !params[:name].nil? && params[:name] != ""
      merchant = Merchant.find_merchant_by_name(params[:name])
      if merchant == nil
        render json: {"data": {}}, status: 400
      else
        render json: MerchantSerializer.new(merchant)
      end
    else
      render json: {"data": {}}, status: 400
    end
  end
end