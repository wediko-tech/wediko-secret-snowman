$(function() {
  $('.wishlist-remove').hide();

  $('form').find(':checkbox').bind('change', function() {
    if ($('input:checkbox:checked').length) {
      $('.wishlist-remove').show();
    } else {
      $('.wishlist-remove').hide();
    }
  });
});