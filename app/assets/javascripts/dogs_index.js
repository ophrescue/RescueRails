GlobalMultiSelect = {};
// 
GlobalMultiSelect.fetch = function(){
  var query = $('form').serialize();
  window.location='/dogs?'+query;
};

GlobalMultiSelect.fetch_all = function(){
  window.location='/dogs';
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

GlobalMultiSelect.selection_callback = function($li){
  var $text_input = $li.closest('ul.dropdown-menu').find('.input-group input.form-control');
  var text = $li.text().trim()
  $text_input.attr('placeholder',`${text} (all/part)`);
  $text_input.focus()
};

GlobalMultiSelect.manage_search_button_visibility = function(){
  var $input = $('#search_field_index input#search');
  var $search_button = $input.closest('.input-group').find('.input-group-append')
  if($input.val().length == 0)
    { $search_button.hide()}else{ $search_button.show()};
};

//GlobalMultiSelect.ensure_attribute_selected = function(){
  //var $target = $(event.target);
  //selected_list_item = $target.closest('ul.dropdown-menu').find('li.selected');
  //if(selected_list_item.length == 0){
    //GlobalMultiSelect.add_error($target,"Please first select (below) the field you wish to search")
    //$target.blur()
  //};
//}

GlobalMultiSelect.add_error=function($field,text){
  $field.after(`<div class='text-input-error'>${text}</div>`)
};

$(function(){
  $(document).on('click', '#reset_message', GlobalMultiSelect.fetch_all );
  $(document).on('click', '.globalselect-container>ul>li>label', GlobalMultiSelect.filter_select );
  $(document).on('keyup', '#filter_controls input#search', GlobalMultiSelect.manage_search_button_visibility );
  //$(document).on('focus', '#filter_controls input#search', GlobalMultiSelect.ensure_attribute_selected );
  $(document).on('click', '#filter_controls .dropdown-menu .input-group#search button', GlobalMultiSelect.fetch );
  //$(document).on('show',GlobalMultiSelect.manage_search_button_visibility)
  //$('#search_field_index').on('shown.bs.dropdown',function(){console.log("baz")})
  $(document).on('show.bs.dropdown',GlobalMultiSelect.manage_search_button_visibility)
});
