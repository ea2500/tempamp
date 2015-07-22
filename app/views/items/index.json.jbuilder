json.array!(@items) do |item|
  json.extract! item, :id, :name, :image_url, :price, :description, :user_id
  json.url item_url(item, format: :json)
end
