$( function(){ 
// ghetto namespace
  if ( $('.edit-adopter').length > 0) {
    var isEditing = false;

    $('a#toggle-edit').on('click', function(e) {
      if (isEditing) {
        // find all disabled fields in .edit-adopter and enable them
        $('form.edit-adopter .to-disable').attr('disabled', 'disabled');
        $('.editable').hide();
        $('.read-only').show();
      }
      else {
        $('form.edit-adopter :disabled').removeAttr('disabled').addClass('to-disable');
        $('.editable').show();
        $('.read-only').hide();
      }

      isEditing = !isEditing;
    })
  }
})
