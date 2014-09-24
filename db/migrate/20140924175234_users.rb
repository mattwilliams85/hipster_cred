class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :topalbums
    end
  end
end
