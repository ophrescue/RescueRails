$( function () {

  if ( $('.edit_comment').length > 0) {
    $(document).on('click', '.toggle-edit-comment', function(e){
      var $parent = $(e.target).parents('form.edit_comment');
      isEditing = $($parent).data("editing");

      if (isEditing) {
        showComment($parent);
      }
      else {
        editComment($parent);
      }
      $($parent).data("editing", !isEditing);

    });

    $(document).on('click', 'button.save-edit-comment', function(e){
      var $parent = $(e.target).parents('form.edit_comment');

      saveComment($parent);
      $parent.find('.toggle-edit-comment').click();
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
});

function editComment($parent) {
  $parent.find('.read-only-comment').hide();
  $parent.find('.editable-comment').show();
  $parent.find('.toggle-edit-comment').removeClass('btn-primary').text('Cancel');
  $parent.find('.save-edit-comment').show();
}

function showComment($parent) {
  $parent.find('.read-only-comment').show();
  $parent.find('.editable-comment').hide();
  $parent.find('.toggle-edit-comment').addClass('btn-primary').text('Edit');
  $parent.find('.save-edit-comment').hide();
}

function saveComment($form) {
  var url = $form.attr('action');
  var serialized_form = $form.serialize();

  $.ajax({
        url: url,
        type: 'POST',
        data: serialized_form
      }).success(function() {
          $.get(url, function(data) {
            $form.find('.read-only-comment').html(data);
          })

        }).error( function() {
          $form.find('.read-only-comment').html("Comment update error.");
          })
}

function refresh_comments() {
  var url = window.location + '/comments';
  $.get(url, function(data) {
    $('#comment_table').html(data);
  });
}
