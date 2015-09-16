json.array!(@alerts) do |alert|
  json.extract! alert, :id, :city_name, :alert_time
  json.url alert_url(alert, format: :json)
end
