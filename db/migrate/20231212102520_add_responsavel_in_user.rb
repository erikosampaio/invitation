class AddResponsavelInUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :responsavel, :string
  end
end
