$( function() {
  if ( $('.edit-adopter').length > 0) {

    var isEditing = false;

    $('button#toggle-edit').on('click', function(e) {
      if (isEditing) {
        // find all disabled fields in .edit-adopter and enable them
        $('form.edit-adopter .to-disable').attr('disabled', 'disabled');
        $('.editable').hide();
        $('.read-only').show();
        $('button#toggle-edit').addClass('btn-primary').text("Edit Info").removeClass('btn-secondary');
        $('input.adopter-save').removeClass('btn-primary').addClass('btn-secondary');
      }
      else {
        $('form.edit-adopter :disabled')
          .removeAttr('disabled')
          .addClass('to-disable');

        $('.editable').show();
        $('.read-only').hide();
        $('button#toggle-edit').removeClass('btn-primary').text("Cancel").addClass('btn-secondary');
        $('input.adopter-save').addClass('btn-primary').removeClass('btn-secondary');
      }

      isEditing = !isEditing;
    });

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

    $('#references').on('click', 'button#toggle-edit-ref', function() {
      if (isRefEditing) {
        // find all enabled fields in .edit-reference and disable them
        $('form.edit-reference .to-disable').prop("disabled", true);
        $('.ref-editable').hide();
        $('.ref-read-only').show();
        $('button#toggle-edit-ref').addClass('btn-primary').text("Edit References").removeClass('btn-secondary');
        $('input.reference-save').removeClass('btn-primary').addClass('btn-secondary');
      }
      else {
        $('form.edit-reference :disabled')
          .removeAttr('disabled')
          .addClass('to-disable');

        $('.ref-editable').show();
        $('.ref-read-only').hide();
        $('button#toggle-edit-ref').removeClass('btn-primary').text("Cancel").addClass('btn-secondary');
        $('input.reference-save').addClass('btn-primary').removeClass('btn-secondary');
      }

      isRefEditing = !isRefEditing;
    });

    var isHousingEditing = false;

    $('#housing').on('click', 'button#toggle-edit-housing', function() {
      if (isHousingEditing) {
        // find all enabled fields in .edit-housing and disable them
        $('form.edit-housing .to-disable').prop("disabled", true);
        $('.rent-editable').hide();
        $('.rent-read-only').show();
        $('button#toggle-edit-housing').addClass('btn-primary').text("Edit Housing Info").removeClass('btn-secondary');
        $('input.housing-save').removeClass('btn-primary').addClass('btn-secondary');
        if ($("#housing [data-house-type]").attr("data-house-type") == 'own'){
          $('.show-rent-parameters').hide();
        }
      }
      else {
        $('form.edit-housing :disabled')
          .removeAttr('disabled')
          .addClass('to-disable');
        $('.show-rent-parameters').show();
        $('.rent-editable').show();
        $('.rent-read-only').hide();
        $('button#toggle-edit-housing').removeClass('btn-primary').text("Cancel").addClass('btn-secondary');
        $('input.housing-save').addClass('btn-primary').removeClass('btn-secondary');
        if ($("#housing [data-house-type]").attr("data-house-type") == 'own'){
          $('.radiobuttonown').prop("checked", true);
        }
        else{
          $('.radiobuttonrent').prop("checked", true);
        }
      }

      isHousingEditing = !isHousingEditing;
    });

    if ($("#housing [data-house-type]").attr("data-house-type") == 'own'){
      $('.show-rent-parameters').hide();
    }

    var isVetEditing = false;

    $('#otherpets').on('click', 'button#toggle-edit-vet', function() {
      if (isVetEditing) {
        // find all enabled fields in .edit-vet and disable them
        $('form.edit-vet .to-disable').prop("disabled", true);
        $('.vet-editable').hide();
        $('.vet-read-only').show();
        $('button#toggle-edit-vet').addClass('btn-primary').text("Edit Vet Info").removeClass('btn-secondary');
        $('input.vet-save').removeClass('btn-primary').addClass('btn-secondary');
      }
      else {
        $('form.edit-vet :disabled')
          .removeAttr('disabled')
          .addClass('to-disable');
        $('.vet-editable').show();
        $('.vet-read-only').hide();
        $('button#toggle-edit-vet').removeClass('btn-primary').text("Cancel").addClass('btn-secondary');
        $('input.vet-save').addClass('btn-primary').removeClass('btn-secondary');
      }

      isVetEditing = !isVetEditing;
    });

    var isInfoEditing = false;

    $('#doginfo').on('click', 'button#toggle-edit-info', function() {
      // find all enabled fields in .edit-info and disable them
      if (isInfoEditing) {
        $('form.edit-info .to-disable').prop("disabled", true);
        $('.info-editable').hide();
        $('.info-read-only').show();
        $('button#toggle-edit-info').addClass('btn-primary').text("Edit Pets Info").removeClass('btn-secondary');
        $('input.info-save').removeClass('btn-primary').addClass('btn-secondary');
      }
      else {
        $('form.edit-info :disabled')
          .removeAttr('disabled')
          .addClass('to-disable');

        $('.info-editable').show();
        $('.info-read-only').hide();
        $('button#toggle-edit-info').removeClass('btn-primary').text("Cancel").addClass('btn-secondary');
        $('input.info-save').addClass('btn-primary').removeClass('btn-secondary');
      }

      isInfoEditing = !isInfoEditing;
    });

    var isChoicesEditing = false;

    $('#dog').on('click', 'button#toggle-edit-pet-choices', function () {
      if (isChoicesEditing) {
        $('form.edit-pet-choices .to-disable').prop("disabled", true);
        $('.pet-choices-editable').hide();
        $('.pet-choices-read-only').show();
        $('button#toggle-edit-pet-choices').addClass('btn-primary').text("Edit Pet Choices").removeClass("btn-secondary");
        $('input.pet-choices-save').removeClass('btn-primary').addClass('btn-secondary');
      } else {
        $('form.edit-pet-choices :disabled')
          .removeAttr('disabled')
          .addClass('to-disable');
        $('.pet-choices-editable').show();
        $('.pet-choices-read-only').hide();
        $('button#toggle-edit-pet-choices').removeClass('btn-primary').text("Cancel").addClass('btn-secondary');
        $('input.pet-choices-save').addClass('btn-primary').removeClass('btn-secondary');
      }

      isChoicesEditing = !isChoicesEditing;
    });
  }
});
