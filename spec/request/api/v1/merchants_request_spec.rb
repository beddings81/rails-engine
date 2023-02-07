require 'rails_helper'

describe 'Merchant API', type: :request do
  it 'sends a list of items' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_a(Array)
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'returns one merchant' do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_a(Hash)

    expect(merchants[:data]).to have_key(:attributes)
    expect(merchants[:data][:attributes]).to be_a(Hash)
    
    expect(merchants[:data][:attributes]).to have_key(:name)
    expect(merchants[:data][:attributes][:name]).to be_a(String)
  end

  it 'returns a merchants items' do
    merchant = create(:merchant)
    items = create_list(:item, 5, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_items).to have_key(:data)
    expect(merchant_items[:data]).to be_a(Array)
    
    merchant_items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)


      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)


      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end
  end
end