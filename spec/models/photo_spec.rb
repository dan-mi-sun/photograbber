require 'spec_helper'

describe Photo do

  # Geocoder.configure(:lookup => :test)
  #
  # Geocoder::Lookup::Test.set_default_stub(
  #   [
  #       {
  #             'latitude'     => 40.7143528,
  #             'longitude'    => -74.0059731,
  #             'address'      => 'New York, NY, USA',
  #             'state'        => 'New York',
  #             'state_code'   => 'NY',
  #             'country'      => 'United States',
  #             'country_code' => 'US'
  #           }
  #     ]
  # )

  describe "importing popular photos from instagram" do
    before do
      example = JSON(File.read('spec/fixtures/popular.json'))

      Instagram.stubs(:media_popular).returns(example)

      @photos =  Photo.import_popular_photos_from_instagram
    end

    it "should make photo objects" do
      expect(@photos.length).to eq(19)
      expect(@photos.first.is_a? Photo).to eq(true)
      expect(@photos.first.image_url).to eq("http://scontent-a.cdninstagram.com/hphotos-xpf1/t51.2885-15/10375865_680303725338476_726384768_n.jpg")
      expect(@photos.first.caption).to eq("Thank you u guys ✨✨")
    end

    it "should save the photos in the database" do
      expect(Photo.count).to eq(19)
    end
  end

  describe "importing nearby photos from instagram" do

    before do
      nearby_example = JSON(File.read('spec/fixtures/search.json'))

      Instagram.stubs(:media_search).returns(nearby_example)

      # Geocoder.stubs(:location).returns("London")
      Geocoder.stubs(:latitude).returns(51.5163)
      Geocoder.stubs(:longitude).returns(-0.08145)

      # @nearby_photos = Photo.import_nearby_photo_from_instagram(51.5184244, -0.08886859999999999)
      @nearby_photos = Photo.import_nearby_photo_from_instagram("London")
    end

    it "should make location objects" do
      expect(@nearby_photos.length).to eq(19)
      expect(@nearby_photos.first.is_a? Photo).to eq(true)
      # expect(@nearby_photos.first.image_url).to eq("http://scontent-b.cdninstagram.com/hphotos-xfp1/t51.2885-15/10299784_782712225093481_1702245848_n.jpg")
      expect(@nearby_photos.first.latitude).to eq(51.5163)
      expect(@nearby_photos.first.name).to eq("Bishopsgate")
    end

    it "should save the photos in the database" do
      expect(Photo.count).to eq(19)
    end
  end
end
