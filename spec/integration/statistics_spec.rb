require "swagger_helper"

RSpec.describe "statistics", type: :request do
  let!(:user) { User.create!(name: "admin", email_address: "admin@example.com", password: "password", role: 0) }
  let(:token) { user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1").token }
  let(:Authorization) { token }
  let!(:client) { Client.create!(name: "Foo", email: "foo@example.com", birthdate: "1990-01-01") }

  path "/statistics/sales_per_day" do
    get("sales per day") do
      tags "Statistics"
      security [bearer_auth: []]
      produces "application/json"

      response(200, "successful") do
        before do
          Sale.create!(client: client, value: 100, description: "sale 1", date: Date.today)
          Sale.create!(client: client, value: 200, description: "sale 2", date: Date.today)
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
  end

  path "/statistics/top_clients" do
    get("top clients") do
      tags "Statistics"
      security [bearer_auth: []]
      produces "application/json"

      response(200, "successful") do
        before do
          client2 = Client.create!(name: "Bar", email: "bar@example.com", birthdate: "1985-01-01")
          Sale.create!(client: client, value: 100, description: "sale 1", date: Date.today)
          Sale.create!(client: client2, value: 200, description: "sale 2", date: Date.today)
          Sale.create!(client: client, value: 300, description: "sale 3", date: Date.today)
        end

        schema type: :object,
          properties: {
            top_volume: {
              type: :object,
              properties: {
                client: {
                  type: :object,
                  properties: {
                    id: {type: :integer},
                    name: {type: :string},
                    email: {type: :string},
                    birthdate: {type: :string, format: "date"},
                    created_at: {type: :string, format: "date-time"},
                    updated_at: {type: :string, format: "date-time"}
                  }
                },
                total: {type: :integer}
              }
            },
            top_average: {
              type: :object,
              properties: {
                client: {
                  type: :object,
                  properties: {
                    id: {type: :integer},
                    name: {type: :string},
                    email: {type: :string},
                    birthdate: {type: :string, format: "date"},
                    created_at: {type: :string, format: "date-time"},
                    updated_at: {type: :string, format: "date-time"}
                  }
                },
                average: {type: :integer}
              }
            },
            top_frequency: {
              type: :object,
              properties: {
                client: {
                  type: :object,
                  properties: {
                    id: {type: :integer},
                    name: {type: :string},
                    email: {type: :string},
                    birthdate: {type: :string, format: "date"},
                    created_at: {type: :string, format: "date-time"},
                    updated_at: {type: :string, format: "date-time"}
                  }
                },
                unique_days: {type: :integer}
              }
            }
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
  end
end
