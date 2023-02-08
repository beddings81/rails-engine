class Api::V1::MerchantController < ApplicationController
  def index
    if Item.exists?(params[:item_id])
      item = Item.find(params[:item_id])
      merchant = item.merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: { "message": "The query could not be completed", :errors => ["Item does not exist"] }, status: 404
    end
  end
end