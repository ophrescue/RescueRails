jQuery(function() {
  return $('#adopters_sort').sortable({
    axis: 'y',
    handle: '> .sort-handle',
    update: function() {
      return $.post($(this).data('update-url'), $(this).sortable('serialize'));
    }
  });
});
