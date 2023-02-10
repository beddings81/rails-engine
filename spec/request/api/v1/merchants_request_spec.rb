require 'rails_helper'

describe 'Merchant API', type: :request do
  describe 'merchants index' do
    describe 'happy path' do
      it 'sends a list of merchants' do
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
    end

    describe 'sad path' do
      it 'returns an error when theres no merchants in the database' do
        get '/api/v1/merchants'

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants).to have_key(:message)
        expect(merchants[:message]).to eq("The query could not be completed")

        expect(merchants).to have_key(:errors)
        expect(merchants[:errors]).to be_a(Array)
        expect(merchants[:errors][0]).to eq("The database is empty")
      end
    end
  end

  describe 'merchants show' do
    describe 'happy path' do
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
    end

    describe 'sad path' do
      it 'returns an error if the merchant does not exist' do
        merchant = create(:merchant)

        get "/api/v1/merchants/#{merchant.id+1}"

        expect(response).to_not be_successful

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)

        expect(merchant).to have_key(:message)
        expect(merchant[:message]).to eq("The query could not be completed")

        expect(merchant).to have_key(:errors)
      end
    end
  end

  describe 'merchant item index' do
    describe 'happy path' do
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

    describe 'sad path' do
      it 'returns an error if the merchant does not exist' do
        merchant = create(:merchant)

        get "/api/v1/merchants/#{merchant.id+1}/items"

        expect(response).to_not be_successful

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)

        expect(merchant).to have_key(:message)
        expect(merchant[:message]).to eq("The query could not be completed")

        expect(merchant).to have_key(:errors)
      end
    end
  end

  describe 'find one merchant' do
    it 'returns a single merchant based off search params' do
       create_list(:merchant, 100)
      
      get "/api/v1/merchants/find?name=O"

      expect(response).to be_successful

      rb = JSON.parse(response.body, symbolize_names: true)
      
      expect(rb).to have_key(:data)

      expect(rb[:data]).to have_key(:id)
      expect(rb[:data]).to have_key(:type)
      expect(rb[:data]).to have_key(:attributes)
    end

    it 'returns an error if no merchant is found' do
      Merchant.create!(name: "party usa")

      get "/api/v1/merchants/find?name=z"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      rb = JSON.parse(response.body, symbolize_names: true)

      expect(rb).to have_key(:data)

      expect(rb[:data]).to eq({})
    end

    it 'returns an error if no param is found' do
      Merchant.create!(name: "party usa")
      Merchant.create!(name: "party canada")

      get "/api/v1/merchants/find?name="

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      rb = JSON.parse(response.body, symbolize_names: true)

      expect(rb).to have_key(:data)

      expect(rb[:data]).to eq({})
    end

    it 'returns an error if no param is found' do
      Merchant.create!(name: "party usa")
      Merchant.create!(name: "party canada")

      get "/api/v1/merchants/find"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      rb = JSON.parse(response.body, symbolize_names: true)

      expect(rb).to have_key(:data)

      expect(rb[:data]).to eq({})
    end
  end
end