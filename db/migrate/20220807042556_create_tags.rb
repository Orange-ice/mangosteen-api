class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.references :user, null: false, foreign_key: false
      t.string :name, limit: 64, null: false
      t.string :sign, limit: 64, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
