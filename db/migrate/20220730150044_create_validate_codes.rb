class CreateValidateCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :validate_codes do |t|
      t.string :email, limit: 64
      t.string :code, limit: 64
      t.datetime :used_at

      t.timestamps
    end
  end
end
