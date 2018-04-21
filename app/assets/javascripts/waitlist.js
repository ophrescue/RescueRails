$(function() {
  $('#new_adopter_link').submit(function(e) {
    e.preventDefault();

    $.ajax({
      type: 'POST',
      url: this.action,
      data: $('#new_adopter_link').serialize(),
      success: function (data) {
        refresh_adopters();
      },
      error: function(a, b, c) {
        $('#add_adopter_submit').prop('disabled', false);
        alert(b + ': ' + c);
      }
    });
  });

  $('#adopter_waitlist_table').on('submit', '#delete_adopter_link', function(e) {
    e.preventDefault();
    if(confirm('Are you sure you would like to delete this?')) {
      $.ajax({
        type: 'POST',
        url: this.action,
        data: $(this).serialize(),
        success: function (data) {
          refresh_adopters();
        },
        statusCode: {
          401: function() {
            alert('not authorized to delete this adopter');
          }
        },
        error: function() {

        }
      });
    }
  })
  function refresh_adopters() {
    var url = window.location;
    $('#adopter_waitlist_table').load(url+' #adopter_waitlist_table');
    $('#add_adopter_submit').prop('disabled', false);
  }

});
