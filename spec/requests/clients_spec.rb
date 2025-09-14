require "rails_helper"

RSpec.describe "/clients", type: :request do
  let!(:user) { User.create!(name: "admin", email_address: "admin@example.com", password: "password") }
  let(:token) { user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1").token }

  let(:valid_attributes) {
    {
      name: "valid_client",
      email: "valid_client@example.com",
      birthdate: "1999-04-24"
    }
  }

  let(:invalid_attributes) {
    {
      name: "invalid_client",
      email: "invalid_client@@email.com",
      birthdate: "29/04/2020"
    }
  }

  let(:valid_headers) {
    { "Authorization" => token.to_s }
  }

  describe "POST /create" do
    context "when age is >= 18" do
      it "creates client" do
        post clients_url,
          params: { client: valid_attributes }, headers: valid_headers, as: :json

        expect(response).to have_http_status(:created)
      end

      it "renders a JSON response with the new client" do
        post clients_url,
          params: { client: valid_attributes }, headers: valid_headers, as: :json

        body = JSON.parse(response.body)
        expect(body["name"]).to eq(valid_attributes[:name])
        expect(body["email"]).to eq(valid_attributes[:email])
        expect(body["birthdate"]).to eq(valid_attributes[:birthdate])
      end
    end

    context "when age is <= 18" do
      it "do not create a client" do
        post clients_url,
          params: { client: invalid_attributes }, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
