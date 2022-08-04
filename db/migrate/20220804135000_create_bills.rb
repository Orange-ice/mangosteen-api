class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.integer :amount
      t.integer :tag_id
      t.integer :user_id
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
