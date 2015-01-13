$( function () {

  if ( $('.edit_comment').length > 0) {
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

      $('.save-edit-comment').click(function() {
        var $parent = $(event.target).parents('.edit-comment')

        save_comment($parent);
        
        $parent.find('.editable-comment').hide();
        $parent.find('.toggle-edit-comment').addClass('btn-primary').text('Edit');
        $parent.find('.save-edit-comment').hide();
        $parent.find('.read-only-comment').show();

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

function save_comment($parent) {
  var $form = $parent
  var serialized_form = $form.serialize();

  $.ajax({
        url: $form.attr('action'),
        type: 'POST',
        data: serialized_form
      }).success(function(data) {
          $parent.find('.read-only-comment').html(data);
        }).error( function() {
          $parent.find('.read-only-comment').html("Comment update error.");
          })
}

function refresh_comments() {
  var url = window.location + '/comments';
  $.get(url, function(data) {
    $('#comment_table').html(data);
  });
}
