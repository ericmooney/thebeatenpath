class RenameSearchColumnFavoritesId < ActiveRecord::Migration
  def change
    rename_column :searches, :favorites_id, :favorite_id
  end
end
