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

  $('#new_cat_link').submit( function(e) {
    e.preventDefault();

    $.ajax({
      type: 'POST',
      url: this.action,
      data: $('#new_cat_link').serialize(),
      success: function (data) {
        refresh_cats();
        clear_cat_autocomplete();
      },
      error: function(a, b, c) {
        $('#link_cat_submit').prop('disabled', false);
        alert(b + ': ' + c);
      }
    });
  });

  $('#parent_linked_cats_table').on('submit', '#delete_cat_link', function(e) {
    e.preventDefault();
    if(confirm('Are you sure you would like to delete this?')) {
      $.ajax({
        type: 'POST',
        url: this.action,
        data: $(this).serialize(),
        success: function (data) {
          refresh_cats();
        },
        statusCode: {
          401: function() {
            alert('not authorized to delete this link');
          }
        },
        error: function() {
        },
      });
    }
  });

});

function refresh_cats() {
  var url = window.location;
  $('#parent_linked_cats_table').load(url+' #linked_cats_table');
  $('#link_cat_submit').prop('disabled', false);
}

function clear_cat_autocomplete() {
  $('#autocomplete_cat_label').val('');
  $('#adoption_cat_id').val('');
}
