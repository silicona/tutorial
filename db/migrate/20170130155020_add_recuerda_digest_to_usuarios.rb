class AddRecuerdaDigestToUsuarios < ActiveRecord::Migration[5.0]
  def change
    add_column :usuarios, :recuerda_digest, :string
  end
end
