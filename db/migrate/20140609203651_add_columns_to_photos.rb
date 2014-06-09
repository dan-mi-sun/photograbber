class AddColumnsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :longitude, :string
    add_column :photos, :latitude, :string
    add_column :photos, :location, :string
  end
end
