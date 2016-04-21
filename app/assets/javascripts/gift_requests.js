$(function() {

  if ($('#gift_request_link').val()) {
    fetchAmazonInfo();
  }

  $('#gift_request_link').on('input', function(e) {
    fetchAmazonInfo();
  });

  function fillForm(name, link) {
    $('#fill-form').click(function() {
      $('#gift_request_name').val(name);
      $('#gift_request_link').val(link);
    });
  }

  function fetchAmazonInfo() {
    var amazonInfo = $('#amazon-info');
    amazonInfo.html('');

    $.ajax({
      url: '/gift_requests/fetch_amazon_info.json',
      type: 'GET',
      data: {'link': $('#gift_request_link').val()},
      success: function(response) {
        // Clear any old information displayed
        if (response) {
          var amazonLink = response.link;
          var link = "<p><a href='" + amazonLink + "'>View Item</a></p>";
          var populateFormBtn = "<p><a id='fill-form' class='btn btn-primary'>Use This Data</a></p>";
          var name = "<p><strong>" + response.name + "</strong></p>";
          var info = $('<div />', {
                        "class": 'alert alert-success'
                      }).html(name + link + populateFormBtn);
          amazonInfo.append(info);
          amazonInfo.removeClass('hide');
          fillForm(response.name, response.link);
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

  var reserveMultipleBtn = $('.catalog-reserve input')
  reserveMultipleBtn.prop('disabled', true);
  $('form :checkbox').bind('change', function(){
    reserveMultipleBtn.prop('disabled', $('input:checkbox:checked').length === 0)
  });
});
