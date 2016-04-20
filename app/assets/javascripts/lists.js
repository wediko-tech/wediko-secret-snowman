$(function() {
  $('.wishlist-remove input').prop('disabled', true);

  $('form').find(':checkbox').bind('change', function() {
    if ($('input:checkbox:checked').length) {
      $('.wishlist-remove input').prop('disabled', false);
    } else {
      $('.wishlist-remove input').prop('disabled', true);
    }
  });
});