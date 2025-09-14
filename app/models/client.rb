class Client < ApplicationRecord
  has_many :sales
  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :name, :email, :birthdate, presence: true
  validates :email, uniqueness: true
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validate :handle_validate_age

  def self.ransackable_attributes(auth_object = nil)
    ["birthdate", "created_at", "email", "id", "name", "updated_at"]
  end

  private

  def handle_validate_age
    return if birthdate.blank?

    if age < 18
      errors.add(:birthdate, "The client should be at least 18 years old.")
    end
  end

  def age
    today = Date.today
    age = today.year - birthdate.year
    age -= 1 if birthdate.to_date.change(year: today.year) > today
    age
  end
end
