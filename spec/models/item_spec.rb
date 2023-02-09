require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
  end

  describe 'associations' do
    it { should belong_to(:merchant) }
  end

  describe '#find_all_by_name' do
    it 'returns an array of items that match the search' do
      merchant = Merchant.create!(name: "Wonderland")
      item1 = Item.create(name:"Turing", description: "description", unit_price: 25.99, merchant_id: merchant.id)
      item2 = Item.create(name:"Silver Ring", description: "description", unit_price: 50.00, merchant_id: merchant.id)
      item3 = Item.create(name:"thing 3", description: "description", unit_price: 150.12, merchant_id: merchant.id)
      item4 = Item.create(name:"not included", description: "description", unit_price: 500.25, merchant_id: merchant.id)

      expect(Item.find_all_by_name("ring")).to eq([item2, item1])
      expect(Item.find_all_by_name("inc")).to eq([item4])
    end
  end
end
