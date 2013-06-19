class AddFromAndToAndSavedToFavorites < ActiveRecord::Migration
  def change
    add_column :favorites, :from, :string
    add_column :favorites, :to, :string
    add_column :favorites, :is_saved, :boolean, :default => false
  end
end
