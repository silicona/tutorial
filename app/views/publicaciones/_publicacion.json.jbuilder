json.extract! publicacion, :id, :contenido, :usuario_id, :created_at, :updated_at
json.url publicacion_url(publicacion, format: :json)