require 'spec_helper'

describe Photo do

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

      @nearby_photos = Photo.import_nearby_photo_from_instagram(51.5184244, -0.08886859999999999)
    end

    it "should make location objects" do
      expect(@nearby_photos.length).to eq(19)
      expect(@nearby_photos.first.is_a? Photo).to eq(true)
      expect(@nearby_photos.first.latitude).to eq(51.522915937)
      expect(@nearby_photos.first.name).to eq("MOO HQ")
    end

    it "should save the photos in the database" do
      expect(Photo.count).to eq(20)
    end
  end
end
