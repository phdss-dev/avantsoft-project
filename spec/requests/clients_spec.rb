require "rails_helper"

RSpec.describe "/clients", type: :request do
  let!(:user) { User.create!(name: "admin", email_address: "admin@example.com", password: "password") }
  let(:token) { user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1").token }

  let(:valid_attributes) {
    {
      name: "valid_client",
      email: "valid_client@example.com",
      birthdate: "24/04/1999"
    }
  }

  let(:invalid_attributes) {
    {
      name: "invalid_client",
      email: "invalid_client@@email.com",
      birthdate: "29/04/1993"
    }
  }

  let(:valid_headers) {
    { "Authorization" => token.to_s }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Client.create! valid_attributes
      get clients_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      client = Client.create! valid_attributes
      get client_url(client), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Client" do
        expect {
          post clients_url,
            params: { client: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Client, :count).by(1)
      end

      it "renders a JSON response with the new client" do
        post clients_url,
          params: { client: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Client" do
        expect {
          post clients_url,
            params: { client: invalid_attributes }, headers: valid_headers, as: :json
        }.to change(Client, :count).by(0)
      end

      it "renders a JSON response with errors for the new client" do
        post clients_url,
          params: { client: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PUT /update" do
    context "with valid parameters" do
      let(:new_valid_attributes) {
        { name: "New name", email: "newemail@email.com" }
      }

      it "renders a JSON response with the client and a status code of 200" do
        client = Client.create! valid_attributes
        put client_url(client),
          params: { client: new_valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      let(:new_invalid_attributes) {
        { name: "", email: "invalid@@email.com" }
      }

      it "renders a JSON response with errors for the client" do
        client = Client.create! valid_attributes
        patch client_url(client),
          params: { client: new_invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested client" do
      client = Client.create! valid_attributes
      expect {
        delete client_url(client), headers: valid_headers, as: :json
      }.to change(Client, :count).by(-1)
    end
  end
end
