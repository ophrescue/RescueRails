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

    $(".cats-q").hide();
    $(".dogs-q").hide();
    $(".current-q").hide();
    $(".pets-type-radio").change(function () {
      if (this.value !== "None") {
        $(".current-q").show();
        if (this.value == "Cats") {
          $(".cats-q").show();
          $(".dogs-q").hide();
        }
        else if (this.value == "Dogs") {
         $(".dogs-q").show();
         $(".cats-q").hide();
        }
        else if (this.value == "Both") {
          $(".cats-q").show();
          $(".dogs-q").show();
        }
      }
      else {
        $(".cats-q").hide();
        $(".dogs-q").hide();
        $(".current-q").hide();
      }
    });
});
