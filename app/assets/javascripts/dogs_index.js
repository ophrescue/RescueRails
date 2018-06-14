//MessageBar = {};
GlobalMultiSelect = {};

//MessageBar.init = function(){
  //$('#filter_info .filter_param').each(function(){
    //var $this = $(this);
    //group = $this.closest('.message_group').attr('id');
    //value = $this.attr('id');
    //if(_.isArray(filter_params[group])){
      //if(filter_params[group].indexOf(value) == -1) {$this.hide()}else{$this.show()}}
    //else if(_.isString(filter_params[group])){
      //if((filter_params[group] == value) ||
        //((filter_params[group] == $this.text()) && $this.text().length > 0) ||
        //((group == 'search') && (filter_params[group].length > 0))
      //) {$this.show()}else{$this.hide()}};
  //});
  //$('#filter_info .message_group').each(function(){
    //var $this = $(this);
    //if($this.find('.filter_param:visible').length == 0)
      //{$this.find('.group_label').hide()}else{$this.find('group_label').show()};
  //});
  //MessageBar.manage_reset_message()
//};

//MessageBar.manage_reset_message = function(){
  //if(!MessageBar.default())
    //{ $('#reset_message').show() }else
    //{ $('#reset_message').hide() };
//};

//MessageBar.show_message = function(group,value,multiple){
  //if(!multiple){$('#filter_info .message_group#'+group+' .filter_param').hide()}
  //var $message = $('#filter_info .message_group .filter_param#'+value);
  //$message.show();
  //$message.parent().find('.group_label').show();
  //MessageBar.manage_reset_message();
//}

//MessageBar.hide_message = function(group,value){
  //var $message = $('#filter_info .message_group .filter_param#'+value);
  //$('#filter_info .message_group .filter_param#'+value).hide()
  //if($message.parent().find('.filter_param:visible').length == 0 )
    //{$message.parent().find('.group_label').hide()};
  //MessageBar.manage_reset_message();
//};

//MessageBar.default = function(){
  //return !(MessageBar.filter_active() || MessageBar.sort_active());
//};

//MessageBar.filter_active = function(){
  //return ($('#filter_info .message_group:not(#sort) .filter_param:visible').length != 0)
//};

//MessageBar.sort_active = function(){
  //var default_sort = 'tracking_id';
  //var selected_sort = $('#filter_info .message_group#sort .filter_param:visible').first().attr('id')
  //return (selected_sort != default_sort)
//};

//MessageBar.show_typed_text = function(group, text){
  //var $message = $('#filter_info .message_group#'+group+' .filter_param');
  //var $group_label = $message.prev()
  //if(text.length == 0){
    //$message.hide();
    //$group_label.hide();
  //}else{
    //$message.show().text(text);
    //$group_label.show();
  //};
//}

GlobalMultiSelect.fetch = function(){
  var query = $('form').serialize();
  window.location='/dogs?'+query;
};

GlobalMultiSelect.fetch_all = function(){
  window.location='/dogs';
};

GlobalMultiSelect.filter_select = function(event){
  $('.text-input-error').remove()
  var $target = $(event.target);
  var $li = $target.parent();
  var multiple = $li.parent().data('multiple')
  var close_after_selection = $li.parent().data('close-after-selection');
  var fetch_immediate = close_after_selection;
  if(!close_after_selection){event.stopPropagation();};
  var $hidden_input = $li.find("input[type='hidden']")
  var group = $li.closest('.globalselect-container').attr('id') // for instance: is_age
  var selectedValue = $li.attr('id'); // for instance: young

  if(multiple){
    var selected = $li.toggleClass('selected').hasClass('selected');
    $hidden_input.prop('disabled',!selected) 
  }else{
    var selected = true;
    // first remove the selected class, and disable hidden inputs, in all sibling list items
    // b/c disabled inputs aren't collected by $('form').serialize()
    $li.siblings().removeClass('selected').find("input[type='hidden']").prop('disabled',true)
    // then select and remove input disable from selected list item
    $li.addClass('selected').find('input').prop('disabled',false) ;
  };

  // only necessary if event propagation is disabled
  //if(selected){
    //MessageBar.show_message(group,selectedValue,multiple)
  //}else{
    //MessageBar.hide_message(group,selectedValue,multiple)
  //}

  if(!multiple){
    filter_params[group] = selectedValue
  };
  if(multiple){
    if(selected){
      filter_params[group].push(selectedValue)
    }else{
      filter_params[group].splice(filter_params[group].indexOf(selectedValue),1)
    }
  }

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

GlobalMultiSelect.filter_by_text_search = function(){
  var $input = $(event.target);
  var $search_button = $input.closest('.input-group').find('.input-group-append')
  if($input.val().length == 0)
    { $search_button.hide()}else{ $search_button.show()};
  var group = $input.attr('id')
  filter_params[group] = $input.val()
  //MessageBar.show_typed_text(group, $input.val())
};

GlobalMultiSelect.ensure_attribute_selected = function(){
  var $target = $(event.target);
  selected_list_item = $target.closest('ul.dropdown-menu').find('li.selected');
  if(selected_list_item.length == 0){
    GlobalMultiSelect.add_error($target,"Please first select (below) the field you wish to search")
    $target.blur()
  };
}

GlobalMultiSelect.add_error=function($field,text){
  $field.after(`<div class='text-input-error'>${text}</div>`)
};

$(function(){
  $(document).on('click', '#reset_message', GlobalMultiSelect.fetch_all );
  $(document).on('click', '.globalselect-container>ul>li>span', GlobalMultiSelect.filter_select );
//  $(document).on('keyup', '#filter_controls #is_breed', GlobalMultiSelect.filter_by_text_search );
  $(document).on('keyup', '#filter_controls input#search', GlobalMultiSelect.filter_by_text_search );
  $(document).on('focus', '#filter_controls input#search', GlobalMultiSelect.ensure_attribute_selected );
  $(document).on('click', '#filter_controls .dropdown-menu .input-group#search button', GlobalMultiSelect.fetch );
  //MessageBar.init();
});

//$(function(){MessageBar.init})
