$( function () {

  if ( $('.edit-comment').length > 0) {
    $('.toggle-edit-comment').each(function(){
      var isEditing = false;

      $(this).click(function() {

        var $parent = $(event.target).parents('.edit-comment')

        if (isEditing) {
          $parent.find('.read-only-comment').show();
          $parent.find('.editable-comment').hide();
          $parent.find('.toggle-edit-comment').addClass('btn-primary').text('Edit');
          $parent.find('.save-edit-comment').hide();
        }
        else {
          $parent.find('.read-only-comment').hide();
          $parent.find('.editable-comment').show();
          $parent.find('.toggle-edit-comment').removeClass('btn-primary').text('Cancel');
          $parent.find('.save-edit-comment').show();
        }
        isEditing = !isEditing;
      });
    });
  }

  $('.save-edit-comment').click(function() {
    var $parent = $(event.target).parents('.edit-comment')
    
    $parent.find('.read-only-comment').show();
    $parent.find('.editable-comment').hide();
    $parent.find('.toggle-edit-comment').addClass('btn-primary').text('Edit');
    $parent.find('.save-edit-comment').hide();
    refresh_comments();

  });

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
