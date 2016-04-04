class AmazonApiFetcher
  include Sidekiq::Worker

  def perform(request_id)
    request = GiftRequest.find(request_id)

    # grab info from link, update gift request
    asin = AmazonProductApi.asin_from_url(request.link)
    result = AmazonProductApi.item_search(asin)

    request.update(
      item_name: result["ItemAttributes"]["Title"],
      category: result["ItemAttributes"]["ProductGroup"],
      link: URI.decode(result["DetailPageURL"])
    )
  end
end
