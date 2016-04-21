class AmazonNoItemFoundError < RuntimeError; end
class AmazonInvalidUrlError < RuntimeError; end
class AmazonProductApi
  class << self
    def item_search(asin)
      results = request.item_search(query: { 'Keywords' => asin, "SearchIndex" => "All" })
        .parse["ItemSearchResponse"]["Items"]

      raise AmazonNoItemFoundError, "Could not find item for ASIN #{asin}" unless results["Item"]

      # if multiple results, return the first one, otherwise return result
      results["Item"].kind_of?(Array) ? results["Item"][0] : results["Item"]
    end

    # adapted from http://stackoverflow.com/questions/1764605/scrape-asin-from-amazon-url-using-javascript
    def asin_from_url(amazon_url)
      asin_regex = /https?:\/\/(?:[^\.]+\.)?amazon\.com\/(?:[\w-]+\/)?(?:dp|gp\/product)\/(?:\w+\/)?(\w{10})/
      if match = asin_regex.match(amazon_url)
        # pull out just the ASIN matcher
        match[1]
      else
        raise AmazonInvalidUrlError, "No ASIN found in URL #{amazon_url}"
      end
    end

    def amazon_link?(link)
      (/amazon\.com/ =~ link).present?
    end

    private

    def request(options = {})
      vacuum = Vacuum.new
      vacuum.configure(options.merge(associate_tag: Rails.configuration.amazon_associate_tag))

      vacuum
    end
  end
end
