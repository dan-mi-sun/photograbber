class Photo < ActiveRecord::Base

  # validates :location, :presence => true

  geocoded_by :location
  after_validation :geocode

  def self.import_popular_photos_from_instagram
    Instagram.media_popular.map do |photo_info|
      p = Photo.new
      p.image_url = photo_info["images"]["standard_resolution"]["url"]
      p.caption = photo_info["caption"]["text"]
      p.save
      p
    end
  end

    def self.import_nearby_photo_from_instagram(location)
      latlng = Geocoder.search(location)
      Instagram.media_search(latlng).map do |nearby_photos|
        p = Photo.new
        p.latitude = nearby_photos["location"]["latitude"]
        p.image_url = nearby_photos["images"]["standard_resolution"]["url"]
        p.name = nearby_photos["location"]["name"]
        p.save!
        p
      end
    end
end
