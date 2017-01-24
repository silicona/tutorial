class CreatePublicaciones < ActiveRecord::Migration[5.0]
  def change
    create_table :publicaciones do |t|
      t.text :contenido
      t.integer :usuario_id

      t.timestamps
    end
  end
end
