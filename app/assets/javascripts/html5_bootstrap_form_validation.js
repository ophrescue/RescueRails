$(function(){
  var $form = $('form.needs-validation');
  var check_form_validity = function(){
    if ($('form.was-validated :input:invalid').length > 0) {
      $('.actions').addClass('form-errors')
    }else{
      $('.actions').removeClass('form-errors')
    }
  }

  var ie11_workaround = function(){
    $('form.needs-validation.was-validated :input').each(function(i,input){
      var invalid_feedback_message = $(input).closest('.form-group').find('.invalid-feedback')
      if(input.checkValidity()){ invalid_feedback_message.hide(); }
      else{ invalid_feedback_message.show(); } })
  }

  var validate_form_fields = function(event){
    var $form = $(event.target)
    if ($form[0].checkValidity() === false) {
      event.preventDefault(); // prevents form submission
      event.stopPropagation();
    }
    $form.addClass('was-validated');
    ie11_workaround()
    check_form_validity();
  }

  // the 'input' event is part of the IE11 workaround, it triggers when the 'x' input for clearing a field is clicked
  $('body').on('change keyup input', 'form.was-validated :input', validate_form_fields )
  $('form.needs-validation').on('submit', validate_form_fields);
});


