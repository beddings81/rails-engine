require 'rails_helper'

describe 'Items API', type: :request do
  it 'sends a list of items' do
    create_list(:item, 4)
   
    get '/api/v1/items'
    
    expect(response).to be_successful
    
    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to have_key(:data)
    expect(items[:data]).to be_a(Array)
    expect(items[:data].count).to eq(4)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it 'can return a single item' do
    i = create(:item)

    get "/api/v1/items/#{i.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to have_key(:data)
    expect(item[:data]).to be_a(Hash)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to be_a(Hash)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to eq("item")

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)


    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)


    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
    expect(item[:data][:attributes][:merchant_id]).to eq(i.merchant.id)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    
  end
end