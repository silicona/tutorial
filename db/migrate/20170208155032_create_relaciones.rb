class CreateRelaciones < ActiveRecord::Migration[5.0]
  def change
    create_table :relaciones do |t|
      t.integer :seguidor_id
      t.integer :seguido_id

      t.timestamps
    end

    # Los index evitan la reduplicacion accidental o intencionada (con curl)
    add_index :relaciones, :seguidor_id
    add_index :relaciones, :seguido_id
    add_index :relaciones, [:seguidor_id, :seguido_id], unique: true
  end
end
