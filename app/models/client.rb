class Client < ApplicationRecord
  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :name, :email, :birthdate, presence: true
  validates :email, uniqueness: true
  validates :email, format: URI::MailTo::EMAIL_REGEXP

  def self.ransackable_attributes(auth_object = nil)
    [ "birthdate", "created_at", "email", "id", "name", "updated_at" ]
  end
end
