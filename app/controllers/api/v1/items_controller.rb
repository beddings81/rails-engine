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

  def create
    new_item = Item.create(item_params)
    if new_item.save
      render json: ItemSerializer.new(new_item), status: :created
    else
      render json: { "message": "The item could not be created", :errors => ["Attributes can't be blank"] }, status: 404
    end
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save
       render json: ItemSerializer.new(item)
    else
      render json: { "message": "The item could not be updated", :errors => ["Attributes can't be blank"] }, status: 404
    end
  end

  def destroy
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      item.invoices.each do |invoice|
        if invoice.only_item?
          invoice.destroy
        end
      end
      item.destroy
    else
      render json: { "message": "The query could not be completed", :errors => ["Item does not exist"] }, status: 404
    end
  end

  private

    def item_params
      params.require(:item).permit(:id, :name, :description, :unit_price, :merchant_id)
    end
end
