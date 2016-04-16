$(function() {

  if ($('#gift_request_link').val()) {
    fetchAmazonItemName();
  }

  $('#gift_request_link').on('input', function(e) {
    fetchAmazonItemName();
  });

  function fetchAmazonItemName() {
    var amazonInfo = $('#amazon-info');
    amazonInfo.html('');

    $.ajax({
      url: '/gift_requests/fetch_amazon_info',
      type: 'GET',
      contentType: "application/json; charset=utf-8",
      data: {'link': $('#gift_request_link').val()},
      success: function(response) {
        // Clear any old information displayed
        if (response) {
          var amazonLink = 'http://www.amazon.com/dp/' + response.asin + '?tag=' + response.associate_tag;
          var link = "<p><a href='" + amazonLink + "'>" + amazonLink + "</a></p>";
          var name = "<p><strong>" + response.item_info.Title + "</strong></p>";
          var info = $('<div />', {
                        "class": 'alert alert-success'
                      }).html(name + link);
          amazonInfo.append(info);
          amazonInfo.removeClass('hide');
        }
        else {
          amazonInfo.addClass('hide');
        }
      },
      error: function(error) {
        var info = $('<div />', {
                      "class": 'alert alert-danger',
                      text: "Could not obtain item information from Amazon!"
                    });
        amazonInfo.append(info);
      }
    });  
  }
});