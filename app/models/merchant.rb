class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items

  def self.find_merchant_by_name(query)
    Merchant
    .where("lower(name) like ?", "%#{query.downcase}%")
    .order(:name)
    .first
  end
end
