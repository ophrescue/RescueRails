$( function() {
  if ( $('.edit-adopter').length > 0) {
    var remoteSource = function(request, response) {
      $.getJSON('/dogs?search=' + request.term, function(data) {
        var results = [];
        data.forEach( function(item) {
          results.push({label: item.name, value: item.id});
        })
        response(results);
      })
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

    $('.autocomplete')
      .autocomplete({
        focus: focusEvent,
        minLength: 2,
        select: itemSelected,
        source: remoteSource
      });
  }
});
