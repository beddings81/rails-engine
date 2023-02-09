require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:items) }
  end

  describe '#find_merchant_by_name' do
    it 'will return one merchant based off the search' do
      merchant1 = Merchant.create!(name: "Turing")
      merchant2 = Merchant.create!(name: "Lord of the Ring")
      merchant3 = Merchant.create!(name: "Ring Her")

      expect(Merchant.find_merchant_by_name("ring")).to eq(merchant2)
      expect(Merchant.find_merchant_by_name("z")).to eq(nil)
    end
  end
end
