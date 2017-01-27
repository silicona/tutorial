class PonerIndexEnUsuariosEmail < ActiveRecord::Migration[5.0]
  def change
  	add_index :usuarios, :email, unique: true
  end
end
