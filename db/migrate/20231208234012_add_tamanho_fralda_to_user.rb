class AddTamanhoFraldaToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :tamanho_fralda, :string
  end
end
