class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone
      t.string :token
      t.boolean :confirmed
      t.string :answered, default: '0'

      t.timestamps
    end
  end
end
