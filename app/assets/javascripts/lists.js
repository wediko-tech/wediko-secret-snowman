$(function() {
  $('.wishlist-remove input').prop('disabled', true);

  $('form').find(':checkbox').bind('change', function() {
    $('.wishlist-remove input').prop('disabled', $('input:checkbox:checked').length === 0);
  });
});
