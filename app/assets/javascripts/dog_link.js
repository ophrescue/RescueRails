$(document).ready( function () {

  $('#new_dog_link').submit( function(e) {
    e.preventDefault();
    $.ajax({
      type: 'POST',
      url: this.action,
      data: $('#new_dog_link').serialize(),
      success: function (data) {
        refresh_dogs();
      },
      error: function() {
        alert('Dog already linked to this application');
      }
    });
  });

  $('#delete_dog_link').live('submit', function(e) {
    e.preventDefault();
    $.ajax({
      type: 'POST',
      url: this.action,
      data: $(this).serialize(),
      success: function (data) {
        // so it worked, add to the comment list
        refresh_dogs();
      },
      statusCode: {
        401: function() {
          alert('not authorized to delete this link');
        }
      },
      error: function() {
      },
    });
  });

});

function refresh_dogs() {
  var url = window.location;
  $('#linked_dogs_table').load(url+' #linked_dogs_table');
}

function delete_comment() {
}
