class Invoice < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def only_item?
    self.items.size <= 1
  end
end