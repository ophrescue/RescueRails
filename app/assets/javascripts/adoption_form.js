$( function() {
  if ( $('.edit-adopter').length > 0) {

    var isEditing = false;

    $('a#toggle-edit').on('click', function(e) {
      if (isEditing) {
        // find all disabled fields in .edit-adopter and enable them
        $('form.edit-adopter .to-disable').attr('disabled', 'disabled');
        $('.editable').hide();
        $('.read-only').show();
        $('a#toggle-edit').addClass('btn-primary').text("Edit Info");
        $('input.adopter-save').removeClass('btn-primary');
      }
      else {
        $('form.edit-adopter :disabled')
          .removeAttr('disabled')
          .addClass('to-disable');

        $('.editable').show();
        $('.read-only').hide();
        $('a#toggle-edit').removeClass('btn-primary').text("Cancel");
        $('input.adopter-save').addClass('btn-primary');
      }

      isEditing = !isEditing;
    });

    $('textarea#adopter_dog_name').on('blur', RescueRails.saveParentForm);

    var remoteSource = function(request, response) {
      $.getJSON('/dogs?autocomplete=true&search=' + request.term, function(data) {
        var results = [];
        data.forEach( function(item) {
          results.push({label: item.name, value: item.id});
        });
        response(results);
      });
    };

    var itemSelected = function(e, ui) {
      $('#autocomplete_label').val(ui.item.label);
      $('#adoption_dog_id').val(ui.item.value);
      return false;
    };

    var focusEvent = function(e, ui) {
      $('#autocomplete_label').val(ui.item.label);
      $('#adoption_dog_id').val(ui.item.value);
      return false;
    };

    var responseHandler = function(e, ui) {
      if (ui.content.length == 1) {
        $('#autocomplete_label').blur();
        ui.item = ui.content[0];
        $(this).data('ui-autocomplete')._trigger('select', 'autocompleteselect', ui);
        $(this).autocomplete('close');
      }
    };

    $('.autocomplete')
      .autocomplete({
        focus: focusEvent,
        minLength: 2,
        response: responseHandler,
        select: itemSelected,
        source: remoteSource
      });

    var isRefEditing = false;

    $('#references').on('click', 'a#toggle-edit-ref', function() {
      if (isRefEditing) {
        // find all enabled fields in .edit-reference and disable them
        $('form.edit-reference .to-disable').prop("disabled", true);
        $('.ref-editable').hide();
        $('.ref-read-only').show();
        $('a#toggle-edit-ref').addClass('btn-primary').text("Edit References");
        $('input.reference-save').removeClass('btn-primary');
      }
      else {
        $('form.edit-reference :disabled')
          .removeAttr('disabled')
          .addClass('to-disable');

        $('.ref-editable').show();
        $('.ref-read-only').hide();
        $('a#toggle-edit-ref').removeClass('btn-primary').text("Cancel");
        $('input.reference-save').addClass('btn-primary');
      }

      isRefEditing = !isRefEditing;
    });

    var isVetEditing = false;

    $('#otherpets').on('click', 'a#toggle-edit-vet', function() {
      if (isVetEditing) {
        // find all enabled fields in .edit-vet and disable them
        $('form.edit-vet .to-disable').prop("disabled", true);
        $('.vet-editable').hide();
        $('.vet-read-only').show();
        $('a#toggle-edit-vet').addClass('btn-primary').text("Edit Vet Info");
        $('input.vet-save').removeClass('btn-primary');
      }
      else {
        $('form.edit-vet :disabled')
          .removeAttr('disabled')
          .addClass('to-disable');

        $('.vet-editable').show();
        $('.vet-read-only').hide();
        $('a#toggle-edit-vet').removeClass('btn-primary').text("Cancel");
        $('input.vet-save').addClass('btn-primary');
      }

      isVetEditing = !isVetEditing;
    });
  }
});
