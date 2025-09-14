require "swagger_helper"

RSpec.describe "Sessions API", type: :request do
  path "/session" do
    post "Authenticate user (login)" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email_address: { type: :string, example: "admin@example.com" },
          password: { type: :string, example: "password" }
        },
        required: %w[email_address password]
      }

      response "200", "authenticated" do
        let(:user) { User.create!(name: "admin", email_address: "admin@example.com", password: "password") }
        let(:credentials) { { email_address: user.email_address, password: "password" } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"]["token"]).to be_present
        end
      end

      response "401", "invalid credentials" do
        let(:credentials) { { email_address: "wrong@example.com", password: "wrong" } }
        run_test!
      end
    end
  end
end
