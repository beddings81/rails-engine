class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    require 'pry'; binding.pry
    # if items == nil
    #   render :json => { :errors => Item.errors.full_messages }
    # else
    #merchant items
      if params[:merchant_id]
        merchant = Merchant.find(params[:merchant_id])
        render json: ItemSerializer.new(merchant.items, merchant)
    #items
      else
        render json: ItemSerializer.new(items)
      end
    # end
  end

  def show
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item)
    else
      render json: { "message": "your query could not be completed", :errors => ["Item does not exist"] }, status: 404
    end
  end
end
