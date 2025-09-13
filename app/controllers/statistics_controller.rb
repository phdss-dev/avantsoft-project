class StatisticsController < ApplicationController
  def sales_per_day
    today_sales = Sale.where(date: Date.today.all_day)

    render json: today_sales, status: :ok
  end

  def top_clients
    top_volume_client_id, total = Sale.group(:client_id).sum(:value).max
    top_volume_client = Client.find(top_volume_client_id)

    top_average_client_id, average = Sale.group(:client_id).average(:value).max
    top_average_client = Client.find(top_average_client_id)

    top_frequency_client_id, unique_days = Sale.group(:client_id)
      .distinct
      .count("DATE(date)")
      .max_by { |client_id, days| days }

    top_frequency_client = Client.find(top_frequency_client_id)

    render json: {
      top_volume: { client: top_volume_client, total: total },
      top_average: { client: top_average_client, average: average.to_i },
      top_frequency: { client: top_frequency_client, unique_days: unique_days }
    }
  end
end
