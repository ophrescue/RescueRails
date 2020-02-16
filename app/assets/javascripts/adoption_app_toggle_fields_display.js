$(document).ready(function () {
    $(".own-home-auth").hide();
    $(".residence-auth-pop").change(function () {
        if (this.value == 'own') {
            $(".own-home-auth").show();
        }
        else {
            $(".own-home-auth").hide();
        }
    });

    $(".birth-date").hide();
    $(".is-of-age-radio").change(function () {
      if (this.value == "false") {
        $(".birth-date").show();
      }
      else {
        $(".birth-date").hide();
      }
    });
});
