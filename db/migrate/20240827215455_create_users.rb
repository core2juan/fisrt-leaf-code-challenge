class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      # Byte limit calculated on worst case scenario 4 bytes per character
      t.string :email,        limit: 800, null: false
      t.string :phone_number, limit: 80,  null: false
      t.string :full_name,    limit: 800
      t.string :password,     limit: 400, null: false
      t.string :key,          limit: 400, null: false
      t.string :account_key,  limit: 400

      # Given the rules described, but since this is using PostgreSQL
      # metadata field would work better as a jsonb
      t.string :metadata,     limit: 8000

      t.timestamps
    end
  end
end
