class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :account_type
    end
  end
end
