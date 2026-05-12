$( function() {
  if ( $('.edit-adopter').length > 0) {

    // Generic toggle-edit factory.
    //
    // Parameters:
    //   tabSelector    – jQuery selector for the containing tab pane (or null for page-level)
    //   buttonSelector – selector for the toggle button
    //   formSelector   – selector for the form whose disabled fields are managed
    //   editableClass  – CSS class that wraps editable inputs  (e.g. '.editable')
    //   readOnlyClass  – CSS class that wraps read-only text   (e.g. '.read-only')
    //   saveSelector   – selector for the save/submit input
    //   editLabel      – button label when in read-only mode   (e.g. "Edit Info")
    //   onEnterEdit    – optional callback invoked when entering edit mode
    //   onExitEdit     – optional callback invoked when leaving edit mode
    function makeToggleHandler(options) {
      var isEditing = false;
      var btn       = $(options.buttonSelector);
      var handler   = function() {
        if (isEditing) {
          // Cancel / exit edit mode
          $(options.formSelector + ' .to-disable').prop('disabled', true);
          $(options.editableClass).hide();
          $(options.readOnlyClass).show();
          btn.addClass('btn-primary').text(options.editLabel).removeClass('btn-secondary');
          $(options.saveSelector).removeClass('btn-primary').addClass('btn-secondary');
          if (options.onExitEdit) { options.onExitEdit(); }
        } else {
          // Enter edit mode
          $(options.formSelector + ' :disabled')
            .removeAttr('disabled')
            .addClass('to-disable');
          $(options.editableClass).show();
          $(options.readOnlyClass).hide();
          btn.removeClass('btn-primary').text('Cancel').addClass('btn-secondary');
          $(options.saveSelector).addClass('btn-primary').removeClass('btn-secondary');
          if (options.onEnterEdit) { options.onEnterEdit(); }
        }
        isEditing = !isEditing;
      };

      if (options.tabSelector) {
        $(options.tabSelector).on('click', options.buttonSelector, handler);
      } else {
        btn.on('click', handler);
      }
    }

    // ── Contact / adopter info panel ─────────────────────────────────────────
    makeToggleHandler({
      tabSelector:    null,
      buttonSelector: 'button#toggle-edit',
      formSelector:   'form.edit-adopter',
      editableClass:  '.editable',
      readOnlyClass:  '.read-only',
      saveSelector:   'input.adopter-save',
      editLabel:      'Edit Info'
    });

    // ── References panel ─────────────────────────────────────────────────────
    makeToggleHandler({
      tabSelector:    '#references',
      buttonSelector: 'button#toggle-edit-ref',
      formSelector:   'form.edit-reference',
      editableClass:  '.ref-editable',
      readOnlyClass:  '.ref-read-only',
      saveSelector:   'input.reference-save',
      editLabel:      'Edit References'
    });

    // ── Housing panel ────────────────────────────────────────────────────────
    makeToggleHandler({
      tabSelector:    '#housing',
      buttonSelector: 'button#toggle-edit-housing',
      formSelector:   'form.edit-housing',
      editableClass:  '.rent-editable',
      readOnlyClass:  '.rent-read-only',
      saveSelector:   'input.housing-save',
      editLabel:      'Edit Housing Info',
      onEnterEdit: function() {
        $('.show-rent-parameters').show();
        var houseType = $('#housing [data-house-type]').attr('data-house-type');
        if (houseType === 'own') {
          $('.radiobuttonown').prop('checked', true);
        } else {
          $('.radiobuttonrent').prop('checked', true);
        }
      },
      onExitEdit: function() {
        if ($('#housing [data-house-type]').attr('data-house-type') === 'own') {
          $('.show-rent-parameters').hide();
        }
      }
    });

    // Hide rental section on page load when owner occupies the home
    if ($('#housing [data-house-type]').attr('data-house-type') === 'own') {
      $('.show-rent-parameters').hide();
    }

    // ── Vet / other pets panel ───────────────────────────────────────────────
    makeToggleHandler({
      tabSelector:    '#otherpets',
      buttonSelector: 'button#toggle-edit-vet',
      formSelector:   'form.edit-vet',
      editableClass:  '.vet-editable',
      readOnlyClass:  '.vet-read-only',
      saveSelector:   'input.vet-save',
      editLabel:      'Edit Vet Info'
    });

    // ── Pet info panel ───────────────────────────────────────────────────────
    makeToggleHandler({
      tabSelector:    '#doginfo',
      buttonSelector: 'button#toggle-edit-info',
      formSelector:   'form.edit-info',
      editableClass:  '.info-editable',
      readOnlyClass:  '.info-read-only',
      saveSelector:   'input.info-save',
      editLabel:      'Edit Pets Info'
    });

    // ── Pet choices panel ────────────────────────────────────────────────────
    makeToggleHandler({
      tabSelector:    '#dog',
      buttonSelector: 'button#toggle-edit-pet-choices',
      formSelector:   'form.edit-pet-choices',
      editableClass:  '.pet-choices-editable',
      readOnlyClass:  '.pet-choices-read-only',
      saveSelector:   'input.pet-choices-save',
      editLabel:      'Edit Pet Choices'
    });

    // ── Cat autocomplete ─────────────────────────────────────────────────────
    var remoteCatSource = function(request, response) {
      $.getJSON('/cats?autocomplete=true&search=' + request.term, function(data) {
        var results = [];
        data.forEach(function(item) {
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
      if (ui.content.length === 1) {
        $('#autocomplete_cat_label').blur();
        ui.item = ui.content[0];
        $(this).data('ui-autocomplete')._trigger('select', 'autocompleteselect', ui);
        $(this).autocomplete('close');
      }
    };

    $('#autocomplete_cat_label').autocomplete({
      focus:    focusCatEvent,
      minLength: 2,
      response: responseCatHandler,
      select:   catSelected,
      source:   remoteCatSource
    });

    // ── Dog autocomplete ─────────────────────────────────────────────────────
    $('textarea#adopter_dog_name').on('blur', RescueRails.saveParentForm);

    var remoteDogSource = function(request, response) {
      $.getJSON('/dogs?autocomplete=true&search=' + request.term, function(data) {
        var results = [];
        data.forEach(function(item) {
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
      if (ui.content.length === 1) {
        $('#autocomplete_dog_label').blur();
        ui.item = ui.content[0];
        $(this).data('ui-autocomplete')._trigger('select', 'autocompleteselect', ui);
        $(this).autocomplete('close');
      }
    };

    $('#autocomplete_dog_label').autocomplete({
      focus:    focusDogEvent,
      minLength: 2,
      response: responseDogHandler,
      select:   dogSelected,
      source:   remoteDogSource
    });
  }
});
