class AddColumnToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :yelp_query, :string
  end
end
