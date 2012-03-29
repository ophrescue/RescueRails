$(document).ready( function () {
  $('#adopter_new_comment').submit( function(e) {
    e.preventDefault();
    $.ajax({
      type: 'POST',
      url: this.action,
      data: $('#adopter_new_comment').serialize(),
      success: function (data) {
        // so it worked, add to the comment list

        // if table is empty it won't have the tbody tag
        var table_body = $('table#comments tbody');
        var comment_table = table_body.length ? table_body : $('table#comments');

        // get template from our hidden div
        var template = $('div#comment_template').attr('data-content');

        // add the template to the table
        comment_table.html( template + comment_table.html() );

        // replace template comment with content
        $('table#comments tbody tr').first().find('#content').html($('#comment_content').val());

        // clear comment field for next comment
        $('#comment_content').val('');
      },
      error: function() {
        alert('error saving comment');
      }
    });
  });
});
