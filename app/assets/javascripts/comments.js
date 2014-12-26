$( function () {
  //$('.edit_comment #comment_content').live('change', RescueRails.saveParentForm);
  
  if ( $('.edit-comment').length > 0) {
    $('.toggle-edit-comment').each(function(){
      var isEditing = false;

      $(this).on('click', function() {

        if (isEditing) {
          $(event.target).parents('.edit-comment').find('.read-only-comment').show();
          $(event.target).parents('.edit-comment').find('.editable-comment').hide();
          $(event.target).parents('.edit-comment').find('.toggle-edit-comment').addClass('btn-primary').text('Edit');
          $(event.target).parents('.edit-comment').find('.save-edit-comment').hide();
        }
        else {
          $(event.target).parents('.edit-comment').find('.read-only-comment').hide();
          $(event.target).parents('.edit-comment').find('.editable-comment').show();
          $(event.target).parents('.edit-comment').find('.toggle-edit-comment').removeClass('btn-primary').text('Cancel');
          $(event.target).parents('.edit-comment').find('.save-edit-comment').show();
        }

        isEditing = !isEditing;
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
