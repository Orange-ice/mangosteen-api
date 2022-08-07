class AddKindToBill < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :kind, :integer, default: 1, null: false
  end
end
