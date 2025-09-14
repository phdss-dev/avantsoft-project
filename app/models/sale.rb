class Sale < ApplicationRecord
  validates :value, :date, :description, presence: true
  validates :value, numericality: true
  belongs_to :client
end
