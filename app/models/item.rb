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

  def self.find_all_by_min_price(min)
    Item
    .where('unit_price >= ?', min)
    .order(:name)
  end

  def self.find_all_by_max_price(max)
    Item
    .where('unit_price <= ?', max)
    .order(:name)
  end

  def self.find_all_in_price_range(min,max)
    Item
    .where('unit_price >= ? AND unit_price <= ?', min, max)
    .order(:name)
  end
end
