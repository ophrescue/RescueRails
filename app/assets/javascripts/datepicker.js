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

$(function() {
  $('#adoption_app_ready_to_adopt_dt').datepicker({
    dateFormat: 'yy-mm-dd',
    maxDate: '+9w',
    minDate: '0d',
    onSelect: RescueRails.saveParentForm
   });

  $('#adopter_adoption_app_attributes_ready_to_adopt_dt').datepicker({
    dateFormat: 'yy-mm-dd',
    maxDate: '+9w',
    minDate: '0d'
   });

  $('#event_event_date').datepicker({
    dateFormat: 'yy-mm-dd',
    maxDate: '+6m',
    minDate: '0d'
  });

  $('#dog_intake_dt').datepicker({
    dateFormat: 'yy-mm-dd'
  });

  $('#dog_available_on_dt').datepicker({
    dateFormat: 'yy-mm-dd'
  });
});
