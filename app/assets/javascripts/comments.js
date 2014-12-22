$( function () {
  //$('.edit_comment #comment_content').live('change', RescueRails.saveParentForm);
  
  if ( $('.edit-comment').length > 0) {
    $('.toggle-edit-comment').each(function(){
      var isEditing = false;

      $(this).click(function(){
        if (isEditing) {
          $('#editable-comment-'+$(this).data('id')).hide();
          $('#read-only-comment-'+$(this).data('id')).show();
          $('#toggle-edit-comment-'+$(this).data('id')).addClass('btn-primary').text('Edit');
          $('#save-edit-comment-'+$(this).data('id')).hide();
        }
        else {
          $('#editable-comment-'+$(this).data('id')).show();
          $('#read-only-comment-'+$(this).data('id')).hide();
          $('#toggle-edit-comment-'+$(this).data('id')).removeClass('btn-primary').text('Cancel');
          $('#save-edit-comment-'+$(this).data('id')).show();
        }

        isEditing = !isEditing
      });


    });
  }

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
    if(confirm('Are you sure you want to delete this?')) {
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
    }
  });
});


function refresh_comments() {
  var url = window.location + '/comments';
  $.get(url, function(data) {
    $('#comment_table').html(data);
  });
}
