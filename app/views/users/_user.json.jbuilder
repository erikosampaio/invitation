json.extract! user, :id, :name, :phone, :token, :confirmed, :answered, :created_at, :updated_at
json.url user_url(user, format: :json)
