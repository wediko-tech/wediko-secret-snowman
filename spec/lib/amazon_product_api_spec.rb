require 'spec_helper'

describe AmazonProductApi do
  describe "#amazon_link?" do
    it "returns true for valid amazon links" do
      expect(AmazonProductApi.amazon_link?("http://www.amazon.com/gp/product/B011SLDC6I/ref=s9_ri_gw_g422_i2_r?ie=UTF8&fpl=fresh"))
        .to eq true
    end

    it "returns false for invalid amazon links" do
      urls = [
        nil,
        "not even a url",
        "http://www.google.com",
        "http://www.amazin.com/gp/product/B011SLDC6I/ref=s9_ri_gw_g422_i2_r?ie=UTF8&fpl=fresh"
      ]

      expect(urls.none?{|url| AmazonProductApi.amazon_link?(url) }).to eq true
    end
  end

  describe "#item_search" do
    it "raises a no item found error for a nonexistent ASIN" do
      expect{ AmazonProductApi.item_search("ferociousbear") }.to raise_error(AmazonNoItemFoundError)
    end

    it "returns a hash" do
      expect(AmazonProductApi.item_search("B011SLDC6I")).to be_kind_of(Hash)
    end
  end

  describe "#asin_from_url" do
    it "returns an ASIN from a valid Amazon URL" do
      url = "http://www.amazon.com/gp/product/B011SLDC6I/ref=s9_ri_gw_g422_i2_r?ie=UTF8&fpl=fresh"
      expect(AmazonProductApi.asin_from_url(url)).to eq "B011SLDC6I"
    end

    it "raises an invalid URL error for invalid Amazon URLs" do
      url = "http://www.amazon.com/no/asin/here"
      expect{ AmazonProductApi.asin_from_url(url) }.to raise_error(AmazonInvalidUrlError)
    end
  end
end
