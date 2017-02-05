class AddReseteoToUsuarios < ActiveRecord::Migration[5.0]
  def change
    add_column :usuarios, :reseteo_digest, :string
    add_column :usuarios, :reseteo_enviado_en, :datetime
  end
end
