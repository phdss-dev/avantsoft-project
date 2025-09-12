class Client < ApplicationRecord
  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :name, :email, :birthdate, presence: true
  validates :email, uniqueness: true
  validates :email, format: URI::MailTo::EMAIL_REGEXP
end
