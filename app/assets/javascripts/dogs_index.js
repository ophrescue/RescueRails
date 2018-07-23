GlobalMultiSelect = {};

GlobalMultiSelect.fetch = function(){
  var query = $('form').serialize();
  window.location='/dogs_manager?'+query;
};

GlobalMultiSelect.search = function(event){
  event.stopPropagation()
  if(GlobalMultiSelect.validate_search()){
    GlobalMultiSelect.fetch()
  }else{
    GlobalMultiSelect.show_search_attribute_missing_error()
    return false
  }
};

GlobalMultiSelect.search_reset = function(event){
  event.stopPropagation();
  $('#search_field_index input#search').val('')
  $('#search_field_index input:radio').prop('checked',false)
  GlobalMultiSelect.manage_search_button_visibility();
  return false;
};

GlobalMultiSelect.search_revert_to_current = function(){
  var index = filter_params.search_field_index
  $("#search_field_index input:radio").prop('checked',false)
  $("#search_field_index ._"+index+" input:radio").prop('checked',true)
  var search = filter_params.search
  $('#search_field_index input#search').val(search)
};

GlobalMultiSelect.validate_search = function(){
  return ($("#search_field_index input:radio:checked").length == 1)
};

GlobalMultiSelect.show_search_attribute_missing_error = function(){
  $('#search-dropdown-heading').replaceWith("<div id='search-error-message' >Please select a field to search in.</div>")
};

GlobalMultiSelect.remove_error = function(){
  $('#search-error-message').remove();
};

GlobalMultiSelect.fetch_all = function(){
  window.location='/dogs_manager';
};

GlobalMultiSelect.filter_select = function(event){
  //$('.text-input-error').remove()
  var $target = $(event.target);
  var $li = $target.closest('li');
  var close_on_select = $li.parent().data('close-on-select');
  var fetch_immediate = close_on_select;
  if(!close_on_select){event.stopPropagation();};

  if(fetch_immediate){
    GlobalMultiSelect.fetch(); // trigger ajax request on any change
  }else{
    GlobalMultiSelect.selection_callback($li);
  }
};

GlobalMultiSelect.selection_callback = function ($li) {
  var $text_input = $li.closest('ul.dropdown-menu').find('.input-group input.form-control');
  var text = $li.text().trim();
  $text_input.attr('placeholder', text + ' (all/part)');
  $text_input.focus();
};

GlobalMultiSelect.manage_search_button_visibility = function(){
  var $input = $('#search_field_index input#search');
  var $search_button = $input.closest('.input-group').find('.input-group-append')
  if($input.val().length == 0)
    { $search_button.hide()}else{ $search_button.show()};
};

GlobalMultiSelect.add_error = function ($field, text) {
  $field.after("<div class='text-input-error'>" + text + "</div>");
};

$(function(){
  $(document).on('click', '#reset_message', GlobalMultiSelect.fetch_all );
  $(document).on('click', '.globalselect-container>ul>li>label', GlobalMultiSelect.filter_select );
  $(document).on('keyup', '#filter_controls input#search', GlobalMultiSelect.manage_search_button_visibility );
  $(document).on('click', '#filter_controls .dropdown-menu .input-group#search #search_button', GlobalMultiSelect.search );
  $(document).on('click', '#filter_controls .dropdown-menu .input-group#search #search_reset_button', GlobalMultiSelect.search_reset );
  $(document).on('change', '#filter_controls .dropdown-menu input:radio', GlobalMultiSelect.remove_error );
  $('#search_field_index').on('show.bs.dropdown',GlobalMultiSelect.manage_search_button_visibility);
  $('#search_field_index').on('hide.bs.dropdown',GlobalMultiSelect.search_revert_to_current);
});
