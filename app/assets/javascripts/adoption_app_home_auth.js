$(document).ready(function() {
    $( ".own-home-auth" ).hide();
    $(".residence-auth-pop").change(function() {
        if (this.value == 'own'){
            $( ".own-home-auth" ).show();
    }
    else if (this.value == 'rent') {
        $( ".own-home-auth" ).hide();
    }
    });
});