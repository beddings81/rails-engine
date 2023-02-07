class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :unit_price, :merchant_id, :description

end
