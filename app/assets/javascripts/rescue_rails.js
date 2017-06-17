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

window.RescueRails = {
  saveParentForm: function() {
    var $form = $(this).parent('form');
    var serialized_form = $form.serialize();
    var $status = $form.find('#status-icon');
    $status.removeClass('fa-check fa-times');

    $.ajax({
      url: $form.attr('action'),
      type: 'POST',
      data: serialized_form
    })
    .done( function(data) {
      $status.addClass('fa fa-check');
      $status.show();
      $status.fadeOut(3000);
    })
    .fail( function(data) {
      $status.addClass('fa fa-times');
      $status.show();
      $status.fadeOut(3000);
    })
  }
};

