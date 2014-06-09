class Photo < ActiveRecord::Base

  def self.import_popular_photos_from_instagram
    Instagram.media_popular.map do |photo_info|
      p = Photo.new
      p.image_url = photo_info["images"]["standard_resolution"]["url"]
      p.caption = photo_info["caption"]["text"]
      p.save
      p
    end
  end

    def self.import_nearby_photo_from_instagram(lat, lng)
      Instagram.media_search(lat, lng).map do |nearby_photos|
        p = Photo.new
        binding.pry
        p.latitude = nearby_photos["location"]["latitude"]
        p.name = nearby_photos["location"]["name"]
      end
    end
end
