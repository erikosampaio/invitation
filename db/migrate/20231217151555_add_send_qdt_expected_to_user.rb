class AddSendQdtExpectedToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :send_qtd_expected, :string, default: 'Não'
  end
end
