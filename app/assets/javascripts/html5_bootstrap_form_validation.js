$(function(){
  var check_form_validity = function(){
    if ($('form.was-validated').is(':invalid')) {
      $('.actions').addClass('form-errors')
    }else{
      $('.actions').removeClass('form-errors')
    }
  }

  $('form :input').on({change: check_form_validity, keyup: check_form_validity })

  var $form = $('form.needs-validation');
  $form.on('submit', function(event){
    if ($form[0].checkValidity() === false) {
      event.preventDefault(); // prevents form submission
      event.stopPropagation();
    }
    $form.addClass('was-validated');
    check_form_validity();
  });
});

