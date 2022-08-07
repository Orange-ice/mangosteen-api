class AddHappenedAtToBill < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :happened_at, :datetime, null: false
  end
end
