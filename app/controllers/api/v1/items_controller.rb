class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    #merchant items
    if params[:merchant_id]
      if Merchant.exists?(params[:merchant_id])
        merchant = Merchant.find(params[:merchant_id])
        render json: ItemSerializer.new(merchant.items, merchant)
      else
        render :json => { "message": "The query could not be completed", :errors => ["Merchant does not exist"] }, status: 404
      end
    #items
    else
      if !items.empty?
        render json: ItemSerializer.new(items)
      else
        render :json => { "message": "The query could not be completed", :errors => ["There are no items in the database", "Merchant does not exist"] }, status: 404
      end
    end
  end

  def show
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item)
    else
      render json: { "message": "The query could not be completed", :errors => ["Item does not exist"] }, status: 404
    end
  end
end
