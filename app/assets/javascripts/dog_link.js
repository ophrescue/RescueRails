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

  $('#new_dog_link').submit( function(e) {
    e.preventDefault();

    $.ajax({
      type: 'POST',
      url: this.action,
      data: $('#new_dog_link').serialize(),
      success: function (data) {
        refresh_dogs();
        clear_dog_autocomplete();
      },
      error: function(a, b, c) {
        $('#link_dog_submit').prop('disabled', false);
        alert(b + ': ' + c);
      }
    });
  });

  $('#parent_linked_dogs_table').on('submit', '#delete_dog_link', function(e) {
    e.preventDefault();
    if(confirm('Are you sure you would like to delete this?')) {
      $.ajax({
        type: 'POST',
        url: this.action,
        data: $(this).serialize(),
        success: function (data) {
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
    }
  });

  $('select#dog_selected').change(function(){
    var select = $(this);
    $('#display_dogs').empty();
    var result = ''
    var pets_id = select.val();
    for(id of pets_id){
      if (!id) {
        continue;
      }
      dogName = select.find("[value="+id+"]").text();
      result = '<li>'+dogName+'</li>'
      $('#display_dogs').append(result);
    }
  })

  $('select#cat_selected').change(function(){
    var select = $(this);
    $('#display_cats').empty();
    var result = ''
    var pets_id = select.val();
    for(id of pets_id){
      if (!id) {
        continue;
      }
      catName = select.find("[value="+id+"]").text();
      result = '<li>'+catName+'</li>'
      $('#display_cats').append(result);
    }
  })

});

function refresh_dogs() {
  var url = window.location;
  $('#parent_linked_dogs_table').load(url+' #linked_dogs_table');
  $('#link_dog_submit').prop('disabled', false);
}

function clear_dog_autocomplete() {
  $('#autocomplete_dog_label').val('');
  $('#adoption_dog_id').val('');
}