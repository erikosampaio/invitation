class AddQtdExpectedToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :qtd_expected, :integer
  end
end
