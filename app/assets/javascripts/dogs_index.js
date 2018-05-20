$(function(){
  console.log("document load")
  GlobalMultiSelect = {};
  var foo = function(event){
    GlobalMultiSelect.filter_select(event)
  }
  $(document).on('click', '.globalselect-container>ul>li>span', foo );

  GlobalMultiSelect.fetch = function(){
    var query = $('form').serialize();
    Turbolinks.visit(`/dogs_manager?${query}`)
  };

  GlobalMultiSelect.filter_select = function(event){
    event.stopPropagation();
    var $target = $(event.target);
    var $li = $target.parent();
    var multiple = $li.parent().data('multiple')
    var $hidden_input = $li.find('input')
    if(multiple){
      var selected = $li.toggleClass('selected').hasClass('selected');
      $hidden_input.prop('disabled',!selected) 
    }else{
      var selected = $li.addClass('selected').hasClass('selected');
      if(selected){ $hidden_input.prop('disabled',false) };
      // remove the selected class from all the other list items
      $li.parent().find('li').each(function(i,el){if(el!=$li[0]){
        $(el).removeClass('selected');
        $(el).find('input').prop('disabled',true)
      }})
    };
    var group = $li.closest('.globalselect-container').attr('id')
    var selectedValue = $li.attr('id');
    if(selected && !multiple){
      filter_params[group] = selectedValue
    };
    if(multiple){
      if(selected){
        filter_params[group][filter_params[group].length] = selectedValue
      }else{
        filter_params[group].splice(filter_params[group].indexOf(selectedValue),1)
      }
    }
    //          context.message_bar.messages(selectedValue, selected, multiple);
    GlobalMultiSelect.fetch(); // trigger ajax request on any change
  };
});
