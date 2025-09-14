require "swagger_helper"

RSpec.describe "sales", type: :request do
  path "/sales" do
    let!(:user) { User.create!(name: "admin", email_address: "admin@example.com", password: "password", role: 0) }
    let(:token) { user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1").token }
    let(:Authorization) { token }
    let!(:client) { Client.create!(name: "Foo", email: "foo@example.com", birthdate: "1990-01-01") }

    get("list sales") do
      tags "Sales"
      security [bearer_auth: []]
      produces "application/json"

      response(200, "successful") do
        before do
          Sale.create!(value: 100, description: "sale 1", date: Date.today, client: client)
        end

        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: {type: :integer},
              client_id: {type: :integer},
              value: {type: :integer},
              date: {type: :string, format: "date-time"},
              description: {type: :string, nullable: true},
              created_at: {type: :string, format: "date-time"},
              updated_at: {type: :string, format: "date-time"}
            },
            required: ["id", "client_id", "value", "date"]
          }
        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }

        schema type: :object,
          properties: {error: {type: :string}},
          required: ["error"]
        run_test!
      end
    end

    post("create sale") do
      tags "Sales"
      security [bearer_auth: []]
      consumes "application/json"
      produces "application/json"

      parameter name: :sale, in: :body, schema: {
        type: :object,
        properties: {
          client_id: {type: :integer},
          value: {type: :integer},
          date: {type: :string, format: "date-time"},
          description: {type: :string}
        },
        required: ["client_id", "value", "date"]
      }

      response(201, "sale created") do
        let(:sale) do
          {
            client_id: client.id,
            value: 150,
            date: "2025-09-14T00:00:00Z",
            description: "First sale"
          }
        end

        schema type: :object,
          properties: {
            sale: {
              type: :object,
              properties: {
                id: {type: :integer},
                client_id: {type: :integer},
                value: {type: :integer},
                date: {type: :string, format: "date-time"},
                description: {type: :string, nullable: true},
                created_at: {type: :string, format: "date-time"},
                updated_at: {type: :string, format: "date-time"}
              }
            }
          }
        run_test!
      end

      response(422, "invalid request") do
        let(:sale) { {client_id: nil, value: "abc"} }

        schema type: :object,
          additionalProperties: {
            type: :array,
            items: {type: :string}
          }
        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }
        let(:sale) { nil }

        schema type: :object,
          properties: {error: {type: :string}},
          required: ["error"]
        run_test!
      end
    end
  end

  path "/sales/{id}" do
    parameter name: "id", in: :path, type: :string, description: "sale id"
    let!(:user) { User.create!(name: "admin", email_address: "admin@example.com", password: "password", role: 0) }
    let(:token) { user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1").token }
    let(:Authorization) { token }
    let!(:client) { Client.create!(name: "Foo", email: "foo@example.com", birthdate: "1990-01-01") }
    let!(:sale_record) { Sale.create!(client_id: client.id, value: 200, date: "2025-09-14T00:00:00Z", description: "Test sale") }

    get("show sale") do
      tags "Sales"
      security [bearer_auth: []]

      response(200, "successful") do
        let(:id) { sale_record.id.to_s }
        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }
        let(:id) { nil }

        schema type: :object,
          properties: {error: {type: :string}},
          required: ["error"]
        run_test!
      end
    end

    patch("update sale") do
      tags "Sales"
      security [bearer_auth: []]
      consumes "application/json"
      produces "application/json"

      parameter name: :sale, in: :body, schema: {
        type: :object,
        properties: {
          value: {type: :integer},
          description: {type: :string}
        }
      }

      response(200, "successful") do
        let(:id) { sale_record.id.to_s }
        let(:sale) { {value: 500, description: "Updated sale"} }
        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }
        let(:id) { nil }
        let(:sale) { nil }

        schema type: :object,
          properties: {error: {type: :string}},
          required: ["error"]
        run_test!
      end
    end

    put("update sale") do
      tags "Sales"
      security [bearer_auth: []]
      consumes "application/json"
      produces "application/json"

      parameter name: :sale, in: :body, schema: {
        type: :object,
        properties: {
          value: {type: :integer},
          description: {type: :string}
        }
      }

      response(200, "successful") do
        let(:id) { sale_record.id.to_s }
        let(:sale) { {value: 800, description: "Replaced sale"} }
        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }
        let(:id) { nil }
        let(:sale) { nil }

        schema type: :object,
          properties: {error: {type: :string}},
          required: ["error"]
        run_test!
      end
    end

    delete("delete sale") do
      tags "Sales"
      security [bearer_auth: []]

      response(204, "no content") do
        let(:id) { sale_record.id.to_s }
        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }
        let(:id) { nil }

        schema type: :object,
          properties: {error: {type: :string}},
          required: ["error"]
        run_test!
      end
    end
  end
end
