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
        $('a#toggle-edit').addClass('btn-primary').text("Edit Address");
        $('input.adopter-save').removeClass('btn-primary');
      }
      else {
        $('form.edit-adopter :disabled').removeAttr('disabled').addClass('to-disable');
        $('.editable').show();
        $('.read-only').hide();
        $('a#toggle-edit').removeClass('btn-primary').text("Cancel");
        $('input.adopter-save').addClass('btn-primary');
      }

      isEditing = !isEditing;
    });

    $('input#adopter_dog_name').on('blur', RescueRails.saveParentForm);
  }
});
