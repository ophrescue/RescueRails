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

    $('select#adopter_dog_or_cat').on('blur', RescueRails.saveParentForm);

    $('textarea#adopter_cat_name').on('blur', RescueRails.saveParentForm);

    var remoteCatSource = function(request, response) {
      $.getJSON('/cats?autocomplete=true&search=' + request.term, function(data) {
        var results = [];
        data.forEach( function(item) {
          results.push({label: item.name, value: item.id});
        });
        response(results);
      });
    };

    var catSelected = function(e, ui) {
      $('#autocomplete_cat_label').val(ui.item.label);
      $('#adoption_cat_id').val(ui.item.value);
      return false;
    };

    var focusCatEvent = function(e, ui) {
      $('#autocomplete_cat_label').val(ui.item.label);
      $('#adoption_cat_id').val(ui.item.value);
      return false;
    };

    var responseCatHandler = function(e, ui) {
      if (ui.content.length == 1) {
        $('#autocomplete_cat_label').blur();
        ui.item = ui.content[0];
        $(this).data('ui-autocomplete')._trigger('select', 'autocompleteselect', ui);
        $(this).autocomplete('close');
      }
    };

    $('#autocomplete_cat_label')
      .autocomplete({
        focus: focusCatEvent,
        minLength: 2,
        response: responseCatHandler,
        select: catSelected,
        source: remoteCatSource
      });

      $('textarea#adopter_dog_name').on('blur', RescueRails.saveParentForm);

      var remoteDogSource = function(request, response) {
        $.getJSON('/dogs?autocomplete=true&search=' + request.term, function(data) {
          var results = [];
          data.forEach( function(item) {
            results.push({label: item.name, value: item.id});
          });
          response(results);
        });
      };

      var dogSelected = function(e, ui) {
        $('#autocomplete_dog_label').val(ui.item.label);
        $('#adoption_dog_id').val(ui.item.value);
        return false;
      };

      var focusDogEvent = function(e, ui) {
        $('#autocomplete_dog_label').val(ui.item.label);
        $('#adoption_dog_id').val(ui.item.value);
        return false;
      };

      var responseDogHandler = function(e, ui) {
        if (ui.content.length == 1) {
          $('#autocomplete_dog_label').blur();
          ui.item = ui.content[0];
          $(this).data('ui-autocomplete')._trigger('select', 'autocompleteselect', ui);
          $(this).autocomplete('close');
        }
      };

      $('#autocomplete_dog_label')
        .autocomplete({
          focus: focusDogEvent,
          minLength: 2,
          response: responseDogHandler,
          select: dogSelected,
          source: remoteDogSource
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

    var isRentalEditing = false;

    $('#rental').on('click', 'a#toggle-edit-rental', function() {
      if (isRentalEditing) {
        // find all enabled fields in .edit-rent and disable them
        $('form.edit-rental .to-disable').prop("disabled", true);
        $('.rental-editable').hide();
        $('.rental-read-only').show();
        $('a#toggle-edit-rental').addClass('btn-primary').text("Edit Rental Info");
        $('input.rental-save').removeClass('btn-primary');
      }
      else {
        $('form.edit-rental :disabled')
          .removeAttr('disabled')
          .addClass('to-disable');

        $('.rental-editable').show();
        $('.rental-read-only').hide();
        $('a#toggle-edit-rental').removeClass('btn-primary').text("Cancel");
        $('input.rental-save').addClass('btn-primary');
      }

      isRentalEditing = !isRentalEditing;
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
