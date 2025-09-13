class SalesController < ApplicationController
  before_action :set_sale, only: %i[show update destroy]

  def index
    @sales = Sale.all

    render json: @sales
  end

  def show
    render json: @sale
  end

  def create
    @sale = Sale.new(sale_params)

    if @sale.save
      render json: @sale, status: :created, location: @sale
    else
      render json: @sale.errors, status: :unprocessable_entity
    end
  end

  def update
    if @sale.update(sale_params)
      render json: @sale
    else
      render json: @sale.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sales/1
  def destroy
    @sale.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = Sale.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def sale_params
    params.expect(sale: [:client_id, :value, :date, :description])
  end
end
