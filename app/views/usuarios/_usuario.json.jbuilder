json.extract! usuario, :id, :nombre, :email, :created_at, :updated_at
json.url usuario_url(usuario, format: :json)