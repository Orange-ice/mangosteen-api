class CreateUsers < ActiveRecord::Migration[7.0]
  # change 方法是对数据库的变动
  def change
    create_table :users do |t|
      t.string :email, limit: 64
      t.string :name, limit: 16

      t.timestamps
    end
  end
end
