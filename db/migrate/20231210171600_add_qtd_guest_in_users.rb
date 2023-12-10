class AddQtdGuestInUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :qtd_guest, :integer, default: 1
  end
end
