class AddColumnsToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :latitude,  :float
    add_column :searches, :longitude, :float
  end
end
