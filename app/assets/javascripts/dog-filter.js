$( document ).ready(function() {

  var flags_set = $('input.dog_filter_cb:checked').size();
  $('span#flagCount').text(flags_set + " selected");

  $('input.dog_filter_cb').change(function() {
    if (this.checked) {
      flags_set++;
    } else {
      flags_set--;
    }
    $('span#flagCount').text(flags_set + " selected");
  });

});
