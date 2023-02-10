class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_response 
  rescue_from ActiveRecord::RecordInvalid, with: :error_response 

  def error_response(error)
    render json: ErrorSerializer.error_json(error), status: 404
  end
  
  def name_conditions
    if params[:name] == ""
      render json: ErrorSerializer.query_error, status: 400
    else
      items = Item.find_all_by_name(params[:name])
      render json: ItemSerializer.new(items)
    end
  end

  def min_price_conditions
   if params[:min_price].to_i < 0
      render json: ErrorSerializer.price_error, status: 400
    else 
      items = Item.find_all_by_min_price(params[:min_price])
      render json: ItemSerializer.new(items)
    end 
  end
  
  def max_price_conditions
    if params[:max_price].to_i < 0
      render json: ErrorSerializer.price_error, status: 400
    else
      items = Item.find_all_by_max_price(params[:max_price])
      render json: ItemSerializer.new(items)
    end
  end
end
