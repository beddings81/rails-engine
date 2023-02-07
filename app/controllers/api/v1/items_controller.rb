class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items, merchant)
    else
      render json: ItemSerializer.new(items)
    end
  end

  def show
    item = Item.find(params[:id])

    render json: ItemSerializer.new(item)
  end
end