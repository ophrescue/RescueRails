//    Copyright 2017 Operation Paws for Homes
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

$( function () {

    $(document).on('click touchstart', '.toggle-edit-comment', function(e){
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


  $('body').on('ajax:success', 'form#new_comment', function(event,result,status) {
    var $form = $(event.target);
    // so it worked, add to the comment list
    refresh_comments(result);

    // reset the form validation class
    $form.removeClass('was-validated')

    // clear comment field for next comment
    $('.comment_content').val('');

    // Turn the POST button back on
    $('.comment_submit').prop('disabled', false);
  });

  $('body').on('ajax:success', 'form.edit_comment', function(event,result,status) {
    var $form = $(event.target);
    var comment_id = $form.find("div[id^=comment_content]").attr('id').match(/\d+/)[0]
    $('.read-only-comment#comment_content_'+comment_id).closest('form').closest('.row').replaceWith(result);
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

function refresh_comments(data) {
  $("[id^='comment_table']").prepend(data);
  $("[id^='all_table']").prepend(data);
}
