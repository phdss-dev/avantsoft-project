require "swagger_helper"

RSpec.describe "clients", type: :request do
  path "/clients" do
    let!(:user) { User.create!(name: "admin", email_address: "admin@example.com", password: "password", role: 0) }
    let(:token) { user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1").token }
    let(:Authorization) { token }

    get("list clients") do
      tags "Clients"
      security [bearer_auth: []]
      produces "application/json"

      parameter name: "q[name_eq]", in: :query, type: :string, description: "Filter clients by exact name"
      parameter name: "q[email_eq]", in: :query, type: :string, description: "Filter clients by exact email"

      response(200, "successful") do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                clients: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      info: {
                        type: :object,
                        properties: {
                          full_name: {type: :string},
                          details: {
                            type: :object,
                            properties: {
                              email: {type: :string, format: :email},
                              birthdate: {type: :string, format: "date"}
                            },
                            required: ["email", "birthdate"]
                          }
                        },
                        required: ["full_name", "details"]
                      },
                      statistics: {
                        type: :object,
                        properties: {
                          sales: {
                            type: :array,
                            items: {
                              type: :object,
                              properties: {
                                date: {type: :string, format: "date"},
                                value: {type: :number}
                              },
                              required: ["date", "value"]
                            }
                          }
                        },
                        required: ["sales"]
                      }
                    },
                    required: ["info", "statistics"]
                  }
                }
              },
              required: ["clients"]
            }
          },
          required: ["data"]

        run_test!
      end
    end

    post("create client") do
      tags "Clients"
      security [bearer_auth: []]
      consumes "application/json"
      produces "application/json"

      parameter name: :client, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string},
          email: {type: :string},
          birthdate: {type: :string, format: "date"}
        },
        required: ["name", "email", "birthdate"]
      }

      response(201, "client created") do
        let(:client) { {name: "foo", email: "bar@example.com", birthdate: "01/01/1991"} }

        schema type: :object,
          properties: {
            client: {
              type: :object,
              properties: {
                name: {type: :string},
                email: {type: :string},
                birthdate: {type: :string, format: "date"}
              }
            }
          }
        run_test!
      end

      response(422, "invalid request") do
        let(:client) { {name: "", email: "bar@example.com", birthdate: "01/01/1991"} }

        schema type: :object,
          additionalProperties: {
            type: :array,
            items: {type: :string}
          }
        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }
        let(:client) { nil }

        schema type: :object,
          properties: {
            error: {type: :string}
          },
          required: ["error"]
        run_test!
      end
    end
  end

  path "/clients/{id}" do
    parameter name: "id", in: :path, type: :string, description: "id"
    let!(:user) { User.create!(name: "admin", email_address: "admin@example.com", password: "password", role: 0) }
    let(:token) { user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1").token }
    let(:Authorization) { token }

    get("show client") do
      tags "Clients"
      security [bearer_auth: []]

      response(200, "successful") do
        let!(:client) { Client.create!(name: "Foo", email: "foo@example.com", birthdate: "1991-01-01") }
        let(:id) { client.id.to_s }

        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }
        let(:id) { nil }

        schema type: :object,
          properties: {
            error: {type: :string}
          },
          required: ["error"]
        run_test!
      end
    end

    patch("update client") do
      tags "Clients"
      security [bearer_auth: []]
      consumes "application/json"
      produces "application/json"

      let!(:client_record) { Client.create(name: "foo", email: "bar@email.com", birthdate: "01/01/1991") }

      parameter name: :client, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string},
          email: {type: :string},
          birthdate: {type: :string, format: "date"}
        }
      }

      response(200, "successful") do
        let(:id) { client_record.id.to_s }
        let(:client) do
          {
            client: {
              name: "Foo - edited",
              email: client_record.email,
              birthdate: client_record.birthdate.to_s
            }
          }
        end
        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }
        let(:id) { nil }
        let(:client) { nil }

        schema type: :object,
          properties: {
            error: {type: :string}
          },
          required: ["error"]
        run_test!
      end
    end

    put("update client") do
      tags "Clients"
      security [bearer_auth: []]
      consumes "application/json"
      produces "application/json"

      parameter name: :client, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string},
          email: {type: :string},
          birthdate: {type: :string, format: "date"}
        }
      }

      let!(:client_record) { Client.create(name: "foo", email: "bar@email.com", birthdate: "1991-01-01") }

      response(200, "successful") do
        let(:id) { client_record.id.to_s }
        let(:client) do
          {
            client: {
              name: "Foo - edited",
              email: client_record.email,
              birthdate: client_record.birthdate.to_s
            }
          }
        end

        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }
        let(:id) { nil }
        let(:client) { nil }

        schema type: :object,
          properties: {
            error: {type: :string}
          },
          required: ["error"]
        run_test!
      end
    end

    delete("delete client") do
      tags "Clients"
      security [bearer_auth: []]

      let!(:client_record) { Client.create(name: "foo", email: "bar@email.com", birthdate: "1991-01-01") }

      response(204, "no content") do
        let(:id) { client_record.id.to_s }
        run_test!
      end

      response(401, "unauthorized") do
        let(:Authorization) { nil }
        let(:id) { nil }

        schema type: :object,
          properties: {
            error: {type: :string}
          },
          required: ["error"]
        run_test!
      end
    end
  end
end
