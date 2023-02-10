class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    if params[:merchant_id]
        merchant = Merchant.find(params[:merchant_id])
        render json: ItemSerializer.new(merchant.items, merchant)
    else
      if !items.empty?
        render json: ItemSerializer.new(items)
      else
        render json: ErrorSerializer.empty_database_error, status: 404
      end
    end
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    new_item = Item.create!(item_params)
    render json: ItemSerializer.new(new_item), status: :created
  end

  def update
    item = Item.find(params[:id])
    item.update!(item_params)
    render json: ItemSerializer.new(item)
  end

  def destroy
    item = Item.find(params[:id])
    item.invoices.each do |invoice|
      if invoice.only_item?
        invoice.destroy
      end
    end
    item.destroy

  end

  private

    def item_params
      params.require(:item).permit(:id, :name, :description, :unit_price, :merchant_id)
    end
end
