require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'associations' do
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe '#only_item?' do
    it 'returns true if the invoice has lesss than or equal to one item' do
      merchant = create(:merchant)
      customer = Customer.create!(first_name: "Johnny", last_name: "Bravo")
      item = create(:item)
      item2 = create(:item)
      invoice1 = Invoice.create!(status: "shipped", merchant_id: merchant.id, customer_id: customer.id)
      invoice2 = Invoice.create!(status: "pending", merchant_id: merchant.id, customer_id: customer.id)

      invoice_item = InvoiceItem.create!(unit_price: 10.99, item_id: item.id, invoice_id: invoice1.id, quantity: 2)
      invoice_item2 = InvoiceItem.create!(unit_price: 12.38, item_id: item2.id, invoice_id: invoice1.id, quantity: 2)
      invoice_item3 = InvoiceItem.create!(unit_price: 5.99, item_id: item2.id, invoice_id: invoice2.id, quantity: 2)

      expect(invoice1.only_item?).to eq(false)
      expect(invoice2.only_item?).to eq(true)
    end
  end
end
