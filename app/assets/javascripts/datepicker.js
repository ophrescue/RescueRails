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
