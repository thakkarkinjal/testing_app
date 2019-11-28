class Product < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 1000000 }
end
