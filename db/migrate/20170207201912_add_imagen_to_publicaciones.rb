class AddImagenToPublicaciones < ActiveRecord::Migration[5.0]
  def change
    add_column :publicaciones, :imagen, :string
  end
end
