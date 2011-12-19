$(document).ready(function() {
  function detectHash() {
    function maybeScrollToHash() {
      if (window.location.hash && $(window.location.hash).length) {
        var newTop = $(window.location.hash).offset().top - $('.topbar').height();
        $(window).scrollTop(newTop);
      }
    }

    $(window).bind('hashchange', function() {
      maybeScrollToHash();
    });

    maybeScrollToHash();
  }
});