require "rails_helper"

RSpec.describe "/sales", type: :request do
  let!(:user) { User.create!(name: "admin", email_address: "admin@example.com", password: "password", role: 0) }
  let(:token) { user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1").token }
  let(:client) { Client.create!(name: "client", email: "client@example.com", birthdate: Date.new(2001, 1, 1)) }

  let(:valid_attributes) {
    {
      value: 100,
      date: Date.today,
      description: "dummy sale",
      client_id: client.id
    }
  }

  let(:invalid_attributes) {
    {
      value: "valor",
      date: Date.today,
      description: "dummy sale",
      client_id: nil
    }
  }

  let(:valid_headers) {
    {"Authorization" => token.to_s}
  }

  describe "POST /create" do
    context "when there is a valid client" do
      it "creates a new sale" do
        expect {
          post sales_url,
            params: {sale: valid_attributes}, headers: valid_headers, as: :json
        }.to change(Sale, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it "renders a JSON response with the new sale" do
        post sales_url,
          params: {sale: valid_attributes}, headers: valid_headers, as: :json

        body = JSON.parse(response.body)
        expect(body["value"]).to eq(valid_attributes[:value])
        expect(body["description"]).to eq(valid_attributes[:description])
        expect(Date.parse(body["date"])).to eq(valid_attributes[:date])
      end
    end

    context "when there is an INVALID client" do
      it "does not create a new sale" do
        expect {
          post sales_url,
            params: {sale: invalid_attributes}, headers: valid_headers, as: :json
        }.to change(Sale, :count).by(0)

        expect(response).to have_http_status(:unprocessable_content)
      end

      it "renders a JSON response with errors for the new sale" do
        post sales_url,
          params: {sale: invalid_attributes}, headers: valid_headers, as: :json

        body = JSON.parse(response.body)

        expect(body["value"]).to include("is not a number")
        expect(body["client"]).to include("must exist")
      end
    end
  end
end
