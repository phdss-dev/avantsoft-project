class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :role, { admin: 0, commom: 1 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
