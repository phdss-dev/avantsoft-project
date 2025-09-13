require "rails_helper"

RSpec.describe Client, type: :model do
  describe "#ransackable_attributes" do
    it "should return a valid array of ransackable attributes" do
      attributes = Client.ransackable_attributes
      ransackable_attributes = [ "birthdate", "created_at", "email", "id", "name", "updated_at" ]

      expect(attributes).to eq(ransackable_attributes)
    end
  end
end
