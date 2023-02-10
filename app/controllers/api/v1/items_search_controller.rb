class Api::V1::ItemsSearchController < ApplicationController
  def index
    if (params[:name] && params[:min_price] || params[:name] && params[:max_price])
      render json: ErrorSerializer.price_error, status: 400
    elsif params[:name]
      name_conditions
    elsif params[:name].nil? && params[:min_price].nil? && params[:max_price].nil?
      render json: ErrorSerializer.query_error, status: 400
    elsif params[:min_price] && params[:max_price]
      items = Item.find_all_in_price_range(params[:min_price], params[:max_price])
      render json: ItemSerializer.new(items)
    elsif params[:min_price]
      min_price_conditions
    elsif params[:max_price]
      max_price_conditions
    end
  end
end