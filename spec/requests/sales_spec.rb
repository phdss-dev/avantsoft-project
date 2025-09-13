require "rails_helper"

RSpec.describe "/sales", type: :request do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Sale.create! valid_attributes
      get sales_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      sale = Sale.create! valid_attributes
      get sale_url(sale), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Sale" do
        expect {
          post sales_url,
            params: { sale: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Sale, :count).by(1)
      end

      it "renders a JSON response with the new sale" do
        post sales_url,
          params: { sale: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Sale" do
        expect {
          post sales_url,
            params: { sale: invalid_attributes }, as: :json
        }.to change(Sale, :count).by(0)
      end

      it "renders a JSON response with errors for the new sale" do
        post sales_url,
          params: { sale: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested sale" do
        sale = Sale.create! valid_attributes
        patch sale_url(sale),
          params: { sale: new_attributes }, headers: valid_headers, as: :json
        sale.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the sale" do
        sale = Sale.create! valid_attributes
        patch sale_url(sale),
          params: { sale: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the sale" do
        sale = Sale.create! valid_attributes
        patch sale_url(sale),
          params: { sale: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested sale" do
      sale = Sale.create! valid_attributes
      expect {
        delete sale_url(sale), headers: valid_headers, as: :json
      }.to change(Sale, :count).by(-1)
    end
  end
end
