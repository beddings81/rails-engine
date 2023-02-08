require 'rails_helper'

describe 'Items API', type: :request do
  describe 'Items index' do
    describe 'happy path' do
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
    end

    describe 'sad path' do
      it 'returns an error when theres no items in the database' do
        get '/api/v1/items'
        
        expect(response).to_not be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items).to have_key(:message)
        expect(items[:message]).to eq("The query could not be completed")

        expect(items).to have_key(:errors)
        expect(items[:errors]).to be_a(Array)
        expect(items[:errors][0]).to eq("There are no items in the database")
      end
    end
  end

  describe 'Items show' do
    describe 'happy path' do
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

    describe 'sad path' do
      it 'returns an error if the item doesnt exist' do
        i = create(:item)

        get "/api/v1/items/#{i.id+1}"

        expect(response).to_not be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)

        expect(item).to have_key(:message)
        expect(item[:message]).to eq("The query could not be completed")

        expect(item).to have_key(:errors)
        expect(item[:errors][0]).to eq("Item does not exist")
      end
    end
  end

  describe 'items create' do
    describe 'happy path' do
      it 'should return a newly created record' do
        merchant = create(:merchant)
        item_params = ({
                  name: 'Murder on the Orient Express',
                  description: 'Agatha Christie',
                  unit_price: 100.99,
                  merchant_id: merchant.id
                  })

        headers = { "CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

        expect(response).to be_successful
        
        rb = JSON.parse(response.body, symbolize_names: true)

        expect(rb).to have_key(:data)
        expect(rb[:data]).to be_a(Hash)

        expect(rb[:data]).to have_key(:id)
        expect(rb[:data][:id]).to be_a(String)

        expect(rb[:data]).to have_key(:type)
        expect(rb[:data][:type]).to be_a(String)
        expect(rb[:data][:type]).to eq("item")

        expect(rb[:data]).to have_key(:attributes)
        expect(rb[:data][:attributes]).to be_a(Hash)

        expect(rb[:data][:attributes]).to have_key(:name)
        expect(rb[:data][:attributes][:name]).to be_a(String)
        
        expect(rb[:data][:attributes]).to have_key(:unit_price)
        expect(rb[:data][:attributes][:unit_price]).to be_a(Float)
        
        expect(rb[:data][:attributes]).to have_key(:merchant_id)
        expect(rb[:data][:attributes][:merchant_id]).to be_a(Integer)
        
        expect(rb[:data][:attributes]).to have_key(:description)
        expect(rb[:data][:attributes][:description]).to be_a(String)
      end
    end

    describe 'sad path' do
      it 'should return an error if any attribute is missing' do
        merchant = create(:merchant)
        item_params = ({
                  name: 'Murder on the Orient Express',
                  description: "",
                  unit_price: 100.99,
                  merchant_id: merchant.id
                  })

        headers = { "CONTENT_TYPE" => "application/json"}

        post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        rb = JSON.parse(response.body, symbolize_names: true)

        expect(rb).to have_key(:message)
        expect(rb[:message]).to eq("The item could not be created")

        expect(rb).to have_key(:errors)
        expect(rb[:errors][0]).to eq("Attributes can't be blank")
      end
    end
  end

  describe 'item update' do
    describe 'happy path' do
      it 'can update an existing item' do
        id = create(:item).id
        previous_name = Item.last.name
        item_params = { name: "New Name" }
        headers = {"CONTENT_TYPE" => "application/json"}
  
        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

        item = Item.find_by(id: id)

        expect(item.name).to_not eq(previous_name)

        expect(response).to be_successful

        rb = JSON.parse(response.body, symbolize_names: true)

        expect(rb).to have_key(:data)
        expect(rb[:data]).to be_a(Hash)

        expect(rb[:data]).to have_key(:id)
        expect(rb[:data][:id]).to be_a(String)

        expect(rb[:data]).to have_key(:type)
        expect(rb[:data][:type]).to be_a(String)
        expect(rb[:data][:type]).to eq("item")

        expect(rb[:data]).to have_key(:attributes)
        expect(rb[:data][:attributes]).to be_a(Hash)

        expect(rb[:data][:attributes]).to have_key(:name)
        expect(rb[:data][:attributes][:name]).to be_a(String)
        
        expect(rb[:data][:attributes]).to have_key(:unit_price)
        expect(rb[:data][:attributes][:unit_price]).to be_a(Float)
        
        expect(rb[:data][:attributes]).to have_key(:merchant_id)
        expect(rb[:data][:attributes][:merchant_id]).to be_a(Integer)
        
        expect(rb[:data][:attributes]).to have_key(:description)
        expect(rb[:data][:attributes][:description]).to be_a(String)

      end
    end

    describe 'sad path' do
      it 'returns an error if attributes are blank' do
        id = create(:item).id
        previous_name = Item.last.name
        item_params = { name: "" }
        headers = {"CONTENT_TYPE" => "application/json"}
  
        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

        item = Item.find_by(id: id)

        expect(item.name).to eq(previous_name)
        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        rb = JSON.parse(response.body, symbolize_names: true)

        expect(rb).to have_key(:message)
        expect(rb[:message]).to eq("The item could not be updated")

        expect(rb).to have_key(:errors)
        expect(rb[:errors][0]).to eq("Attributes can't be blank")
      end
    end
  end

  describe 'item delete' do
    describe 'happy path' do
      it 'can delete an item and any invoice where its the only item' do
        merchant = create(:merchant)
        customer = Customer.create!(first_name: "Johnny", last_name: "Bravo")
        item = create(:item)
        item2 = create(:item)
        invoice1 = Invoice.create!(status: "shipped", merchant_id: merchant.id, customer_id: customer.id)
        invoice2 = Invoice.create!(status: "pending", merchant_id: merchant.id, customer_id: customer.id)

        invoice_item = InvoiceItem.create!(unit_price: 10.99, item_id: item.id, invoice_id: invoice1.id, quantity: 2)
        invoice_item2 = InvoiceItem.create!(unit_price: 12.38, item_id: item2.id, invoice_id: invoice1.id, quantity: 2)
        invoice_item3 = InvoiceItem.create!(unit_price: 5.99, item_id: item2.id, invoice_id: invoice2.id, quantity: 2)

        expect(Invoice.count).to eq(2)

        delete "/api/v1/items/#{item2.id}"

        expect(response).to be_successful
        expect(response.status).to eq(204)
        expect(Invoice.count).to eq(1)
      end
    end
    
    describe 'sad path' do
      it 'returns an error if the item is not found' do
        item = create(:item)

        delete "/api/v1/items/#{item.id+1}"
        #+1 wont work with new error handling
        expect(response).to_not be_successful

        rb = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)

        expect(rb).to have_key(:message)
        expect(rb[:message]).to eq("The query could not be completed")

        expect(rb).to have_key(:errors)
        expect(rb[:errors][0]).to eq("Item does not exist")
      end
    end
  end

  describe 'item merchant relationship' do
    describe 'happy path' do
      it 'returns the merchant associated with the item' do
        item = create(:item)

        get "/api/v1/items/#{item.id}/merchant"

        expect(response).to be_successful
        
        rb = JSON.parse(response.body, symbolize_names: true)

        expect(rb).to have_key(:data)
        expect(rb[:data]).to be_a(Hash)

        expect(rb[:data]).to have_key(:id)
        expect(rb[:data]).to have_key(:type)
        expect(rb[:data]).to have_key(:attributes)
      end
    end

    describe 'sad path' do
      it 'returns an error if the item is not found' do
        item = create(:item)

        get "/api/v1/items/#{item.id+1}/merchant"
        #+1 wont work with new error handling
        expect(response).to_not be_successful

        rb = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)

        expect(rb).to have_key(:message)
        expect(rb[:message]).to eq("The query could not be completed")

        expect(rb).to have_key(:errors)
        expect(rb[:errors][0]).to eq("Item does not exist")

      end
    end
  end
end