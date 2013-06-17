class FavoritesUsersBridge < ActiveRecord::Migration
  def change
     create_table :favorites_users do |t|
      t.integer :favorite_id
      t.integer :user_id
     end
  end
end
