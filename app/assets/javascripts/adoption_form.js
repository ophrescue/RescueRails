$( function() {
  if ( $('.edit-adopter').length > 0) {
    var remoteSource = function(request, response) {
      $.getJSON('/dogs?all_dogs=true&search=' + request.term, function(data) {
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

    var focusEvent = function(event, ui) {
      $('#autocomplete_label').val(ui.item.label);
      return false;
    };

    var responseHandler = function(event, ui) {
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
  }
});
