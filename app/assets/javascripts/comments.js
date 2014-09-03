$( function () {
  $('.edit_comment #comment_content').live('change', RescueRails.saveParentForm);

  $('#new_comment').submit( function(e) {
    e.preventDefault();
    $.ajax({
      type: 'POST',
      url: this.action,
      data: $('#new_comment').serialize(),
      success: function (data) {
        // so it worked, add to the comment list
        refresh_comments();

        // clear comment field for next comment
        $('#comment_content').val('');
      },
      error: function() {
        alert('error saving comment');
      }
    });
  });

  $('#delete_comment').live('submit', function(e) {
    e.preventDefault();
    $.ajax({
      type: 'POST',
      url: this.action,
      data: $(this).serialize(),
      success: function (data) {
        // so it worked, add to the comment list
        refresh_comments();
      },
      statusCode: {
        401: function() {
          alert('not authorized to delete this comment');
        }
      },
      error: function() {
      },
    });
  });
});


function refresh_comments() {
  var url = window.location + '/comments';
  $.get(url, function(data) {
    $('#comment_table').html(data);
  });
}
