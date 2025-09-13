
json.data do
  json.clients @clients do |client|
    json.info do
      json.full_name client.name
      json.details do
        json.email client.email
        json.birthdate client.birthdate
      end
    end

    json.statistics do
      json.sales client.sales do |sale|
        json.date sale.date.to_date
        json.value sale.value
      end
    end
  end
end
