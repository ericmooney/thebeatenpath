class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :address
      t.string :name
      t.integer :favorites_id

      t.timestamps
    end
  end
end
