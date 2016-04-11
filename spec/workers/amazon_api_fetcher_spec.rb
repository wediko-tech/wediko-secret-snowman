require 'spec_helper'

describe AmazonApiFetcher, inline_jobs: true do
  EXAMPLE_RESPONSE = {
    "ASIN"=>"B011SLDC6I",
    "ParentASIN"=>"B019ELIJXA",
    "DetailPageURL"=>"http://www.amazon.com/Apple-iPod-Touch-Space-Generation/dp/B011SLDC6I%3Fpsc%3D1%26SubscriptionId%3DAKIAI62265LOHALC35PA%26tag%3Dwdk%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB011SLDC6I",
    "ItemLinks"=>
    {
      "ItemLink"=>
      [
        {
          "Description"=>"Technical Details",
          "URL"=>"http://www.amazon.com/Apple-iPod-Touch-Space-Generation/dp/tech-data/B011SLDC6I%3FSubscriptionId%3DAKIAI62265LOHALC35PA%26tag%3Dwdk%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB011SLDC6I"
        },
        {
          "Description"=>"Add To Baby Registry",
          "URL"=>"http://www.amazon.com/gp/registry/baby/add-item.html%3Fasin.0%3DB011SLDC6I%26SubscriptionId%3DAKIAI62265LOHALC35PA%26tag%3Dwdk%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB011SLDC6I"
        },
        {
          "Description"=>"Add To Wedding Registry",
          "URL"=>"http://www.amazon.com/gp/registry/wedding/add-item.html%3Fasin.0%3DB011SLDC6I%26SubscriptionId%3DAKIAI62265LOHALC35PA%26tag%3Dwdk%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB011SLDC6I"
        },
        {
          "Description"=>"Add To Wishlist",
          "URL"=>"http://www.amazon.com/gp/registry/wishlist/add-item.html%3Fasin.0%3DB011SLDC6I%26SubscriptionId%3DAKIAI62265LOHALC35PA%26tag%3Dwdk%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB011SLDC6I"
        },
        {
          "Description"=>"Tell A Friend",
          "URL"=>"http://www.amazon.com/gp/pdp/taf/B011SLDC6I%3FSubscriptionId%3DAKIAI62265LOHALC35PA%26tag%3Dwdk%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB011SLDC6I"
        },
        {
          "Description"=>"All Customer Reviews",
          "URL"=>"http://www.amazon.com/review/product/B011SLDC6I%3FSubscriptionId%3DAKIAI62265LOHALC35PA%26tag%3Dwdk%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB011SLDC6I"
        },
        {
          "Description"=>"All Offers",
          "URL"=>"http://www.amazon.com/gp/offer-listing/B011SLDC6I%3FSubscriptionId%3DAKIAI62265LOHALC35PA%26tag%3Dwdk%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB011SLDC6I"
        }
      ]
    },
    "ItemAttributes"=>
    {
      "Manufacturer"=>"Apple",
      "ProductGroup"=>"CE",
      "Title"=>"Apple iPod Touch 16GB Space Gray (6th Generation)"
    }
  }
  describe "#perform" do
    before :each do
      @gift_request = FactoryGirl.create(:gift_request, link: "http://www.amazon.com/gp/product/B011SLDC6I/")
    end

    it "updates a gift request's URL, name, and category" do
      allow(AmazonProductApi).to receive(:item_search).with("B011SLDC6I") { EXAMPLE_RESPONSE }

      AmazonApiFetcher.perform_async(@gift_request.id)
      @gift_request.reload

      query_params_hash = Rack::Utils.parse_nested_query(URI.parse(@gift_request.link).query)
      expect(query_params_hash['tag']).to eq "wdk"
      expect(@gift_request.name).to include "iPod Touch"
      expect(@gift_request.category).to eq "CE"

      allow(AmazonProductApi).to receive(:item_search).and_call_original
    end
  end
end
