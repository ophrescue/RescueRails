$(function() {
  $('#new_adopter_add').submit(function(e) {
    e.preventDefault();

    console.log($('#new_adopter_add').serialize());
    console.log(this.action);

    $.ajax({
      type: 'POST',
      url: this.action + '/adopter_waitlists',
      data: $('#new_adopter_add').serialize(),
      success: function (data) {
        alert('success')
      },
      error: function(a, b, c) {
        $('#add_adopter_submit').prop('disabled', false);
        alert(b + ': ' + c);
      }
    });
  })
})
