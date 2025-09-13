class ClientsController < ApplicationController
  before_action :set_client, only: %i[show update destroy]

  def index
    @q = Client.ransack(params[:q])
    @clients = @q.result(distinct: true)
  end

  def show
    render json: @client
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      render json: @client, status: :created, location: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      render json: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy!
  end

  private

  def set_client
    @client = Client.find(params.expect(:id))
  end

  def client_params
    params.expect(client: [ :name, :email, :birthdate ])
  end
end
