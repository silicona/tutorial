class AddActivacionToUsuarios < ActiveRecord::Migration[5.0]
  def change
    add_column :usuarios, :activacion_digest, :string
    add_column :usuarios, :activado, :boolean
    add_column :usuarios, :activado_en, :datetime
  end
end
