class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def self.find_all_by_name(query)
    Item
    .where('lower(name) like ?', "%#{query.downcase}%")
    .order(:name)
  end
end
