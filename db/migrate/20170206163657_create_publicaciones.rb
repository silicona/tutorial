class CreatePublicaciones < ActiveRecord::Migration[5.0]
  def change
    create_table :publicaciones do |t|
      t.text :contenido
      t.references :usuario, foreign_key: true

      t.timestamps
    end

    add_index :publicaciones, [:usuario_id, :created_at]
  end
end
