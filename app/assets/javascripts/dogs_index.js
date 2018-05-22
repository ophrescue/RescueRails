MessageBar = {};
GlobalMultiSelect = {};

MessageBar.init = function(){
  $('#filter_info .filter_param').each(function(){
    var $this = $(this);
    group = $this.closest('.message_group').attr('id');
    value = $this.attr('id');
    if(_.isArray(filter_params[group])){
      if(filter_params[group].indexOf(value) == -1) {$this.hide()}else{$this.show()}}
    else if(_.isString(filter_params[group])){
      if((filter_params[group] == value) || ((filter_params[group] == $this.text()) && $this.text().length > 0)) {$this.show()}else{$this.hide()}};
  });
  $('#filter_info .message_group').each(function(){
    var $this = $(this);
    if($this.find('.filter_param:visible').length == 0)
      {$this.find('.group_label').hide()}else{$this.find('group_label').show()};
  });
  MessageBar.manage_reset_message()
};

MessageBar.manage_reset_message = function(){
  if(!MessageBar.default())
    { $('#reset_message').show() }else
    { $('#reset_message').hide() };
};

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

MessageBar.default = function(){
  return !(MessageBar.filter_active() || MessageBar.sort_active());
};

MessageBar.filter_active = function(){
  return ($('#filter_info .message_group:not(#sort) .filter_param:visible').length != 0)
};

MessageBar.sort_active = function(){
  var default_sort = 'tracking_id';
  var selected_sort = $('#filter_info .message_group#sort .filter_param:visible').first().attr('id')
  return (selected_sort != default_sort)
};

MessageBar.show_typed_text = function(group, text){
  var $message = $('#filter_info .message_group#'+group+' .filter_param');
  var $group_label = $message.prev()
  if(text.length == 0){
    $message.hide();
    $group_label.hide();
  }else{
    $message.show().text(text);
    $group_label.show();
  };
}

GlobalMultiSelect.fetch = function(){
  console.log($('form').serialize());
  var query = $('form').serialize();
  Turbolinks.visit(`/dogs_manager?${query}`)
};

GlobalMultiSelect.fetch_all = function(){
  Turbolinks.visit('/dogs_manager')
};

GlobalMultiSelect.filter_select = function(event){
  //event.stopPropagation(); // it seems to be preferable to close the dropdown after clicking, but others might not agree
  var $target = $(event.target);
  var $li = $target.parent();
  var multiple = $li.parent().data('multiple')
  var $hidden_input = $li.find('input')
  var group = $li.closest('.globalselect-container').attr('id') // for instance: is_age
  var selectedValue = $li.attr('id'); // for instance: young

  if(multiple){
    var selected = $li.toggleClass('selected').hasClass('selected');
    $hidden_input.prop('disabled',!selected) 
  }else{
    var selected = true;
    // first remove the selected class, and disable hidden inputs, in all sibling list items
    // b/c disabled inputs aren't collected by $('form').serialize()
    $li.siblings().removeClass('selected').find('input').prop('disabled',true)
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

  GlobalMultiSelect.fetch(); // trigger ajax request on any change
};

GlobalMultiSelect.filter_by_text_search = function(){
  var $input = $(event.target);
  var $search_button = $input.next();
  if($input.val().length == 0)
    { $search_button.hide()}else{ $search_button.show()};
  var group = $input.attr('id')
  filter_params[group] = $input.val()
  MessageBar.show_typed_text(group, $input.val())
};

$(function(){
  $(document).on('click', '#reset_message', GlobalMultiSelect.fetch_all );
  $(document).on('click', '.globalselect-container>ul>li>span', GlobalMultiSelect.filter_select );
  $(document).on('keyup', '#filter_controls #is_breed', GlobalMultiSelect.filter_by_text_search );
  $(document).on('click', '#filter_controls #breed button', GlobalMultiSelect.fetch );
  MessageBar.init();
});

$(function(){MessageBar.init})
