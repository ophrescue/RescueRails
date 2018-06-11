console.log("eval my script")
function SortFilterMessageBar(options, globalMultiSelect) {
    this.$globalMessageField = $('#'+options.globalMessageField);
    this.filter_params = window.filter_params
    this.globalMultiSelect = globalMultiSelect

    this.make_message_group_label = function(group_id, group_text){
      span_id = `${group_id}_group`
      this.$globalMessageField.prepend($(`<span class='message_group ${span_id}'></span>`));
      this.$globalMessageField.find(`.message_group.${span_id}`).append($(`<span class='group_label ${span_id}'>${group_text}: </span>`).hide());
    };

    this.make_message = function(group_id, group_text, id, text){
      span_id = `${group_id}_group`
      this.$globalMessageField.find(`.message_group.${span_id}`).append($(`<span class='filter_param' id=${id}>${text}</span>`).hide());
    };

    this.make_message_group = function(id, buttonText,selectOptions){
      this.make_message_group_label(id, buttonText)
      for(var key in selectOptions){
        this.make_message(id, buttonText, key, selectOptions[key])
      }
    };

    this.messages = function(selectedValue, selected, multiple){
      var $selectedMessage = this.$globalMessageField.find(`#${selectedValue}`);
      var $messageGroup = $selectedMessage.closest('.message_group');
      if(!multiple){$messageGroup.find('.filter_param').hide()};
      if(selected){
        $messageGroup.find('.group_label').show();
        $selectedMessage.show();
      }else{
        $selectedMessage.hide();
        if($messageGroup.find('.filter_param:visible').length == 0) {
          $messageGroup.find('.group_label').hide();
        }
      }
      this.show_reset_link()
    };

    this.search_sort_filter_active = function(){
      for(var filter_group in this.filter_params){
        var filter_attrs = this.filter_params[filter_group]
        var multiselect_active = (_.isArray(filter_attrs) && (filter_attrs.length > 0))
        var sort_active = (!_.isArray(filter_attrs) && filter_attrs != "tracking_id")
        if ( multiselect_active || sort_active ){ return true }
      }
      return false
    };

    this.show_reset_link = function(){
      if(this.search_sort_filter_active()){
        $('#reset_message').show()
      }else{
        $('#reset_message').hide()
      }
    };

    this.initialize = function(){
      this.$globalMessageField.append( '<span id="reset_message"><i class="fa fa-times" aria-hidden="true"></i> Reset filter, search and sort</span>');
      var that = this;
      $('#reset_message').on('click', function(){
        that.globalMultiSelect.reset()
      })
    }
    //this.initialize();
  };

function GlobalMultiSelect(options) {

  this.filter_params = window.filter_params
  this.message_bar = new SortFilterMessageBar(options, this)
  this.$container = $('#'+options.container);
  this.sort_param = ""
  this.templates = function(){
    return {wrapper: `<div class="col-sm globalselect-container"></div>`,
      button:  `<button type="button" class="globalselect dropdown-toggle btn btn-sm btn-default" data-toggle="dropdown" aria-expanded="true"></button>`,
      ul: `<ul class="dropdown-menu" x-placement="bottom-start" style="position: absolute; transform: translate3d(0px, 38px, 0px); top: 0px; left: 0px; will-change: transform; min-width: max-content; padding-right: 8px"></ul>`,
      li: `<li><span class='check fa fa-check'></span><span></span></li>`,
      breed_field: "<div class='col-sm'><input type='text' id='is_breed' name='is_breed' placeholder='Breed (all/part)'></div>"
    }
  }

  this.addDropdown = function (options){
    var $id = '#'+options.id
    var templates = this.templates()
    var $wrapper = $(templates.wrapper).attr('id',options.id)
    this.$container.prepend($wrapper)
    $wrapper.append(templates.button);
    $('.globalselect',$id).text(options.buttonText);
    $('.globalselect',$id).after(templates.ul);
    this.message_bar.make_message_group(options.id, options.buttonText,options.selectOptions)
    //if(options.multiple){
      //this.filter_params[options.id] = []
    //}else{
      //this.filter_params[options.id] = null
    //}
    for(var key in options.selectOptions){
      this.addDropdownItem($id, options.id, key, options.selectOptions[key])
    }
    this.activate($wrapper,options.multiple);
  };

  this.addDropdownItem = function($id, key, value, text){
    var templates = this.templates()
    var list_item = $(templates.li)
    list_item.attr('id',value).find('span:last-child').text(text)
    if(_.isArray(filter_params[key]) && (_.indexOf(filter_params[key],value) != -1)){
      list_item.addClass('selected')
    }else if(filter_params[key]==value){
      list_item.addClass('selected')
    }
    $('ul',$id).append(list_item)
  };

  this.activate = function(dropdown, multiple){
    var context = this
    dropdown.find('span').on('click', {context:context, multiple:multiple}, this.select);
    $('.dropdown-menu li').on('click',function(event){event.stopPropagation()})
  };


  this.select = function(event){
    var $target = $(event.target);
    var $li = $target.parent();
    var multiple = event.data.multiple;
    if(multiple){
      var selected = $li.toggleClass('selected').hasClass('selected');
    }else{
      var selected = $li.addClass('selected').hasClass('selected');
      // remove the selected class from all the other list items
      $li.parent().find('li').each(function(i,el){if(el!=$li[0]){$(el).removeClass('selected')}})
    };
    var context = event.data.context;
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
    context.message_bar.messages(selectedValue, selected, multiple);
    context.fetch(); // trigger ajax request on any change
  };

  this.filter_query = function(){
    var base = "utf8=✓&commit=Filter";
    _.forEach(filter_params, function(attr_list, group){
      if(_.isArray(attr_list)){
        _.forEach(attr_list, function(attr){
          base = base+"&"+group+"[]="+attr
        })
      }else{
        base = base+"&"+group+"="+attr_list
      };
    })
    return base
  };

  this.fetch = function(){
    //$('#manager_dogs').load("/dogs_manager #manager_dogs>div", this.filter_query(), this.handle_ajax_response )
    Turbolinks.visit(`/dogs_manager?${this.filter_query()}`)
  };

  this.reset = function(){
    for(var filter_group in this.filter_params){
      var filter_attrs = this.filter_params[filter_group]
      if( _.isArray(filter_attrs)){ filter_params[filter_group] = [] }else{ filter_params[filter_group] = "tracking_id" }
    }
    this.fetch()
  };

  //this.handle_ajax_response = function(){console.log("ajax success")};

  /*this.initialize = function(){
    console.log("initialize")
    var templates = this.templates()
    this.addDropdown({id:"sort", buttonText:"Sort", selectOptions: sort_fields, multiple:false})
    this.$container.prepend(templates.breed_field);
    _.each(filter_params,function(attr_list,group){
      if(_.isArray(attr_list)){
        _.each(attr_list,function(attr){
        })
      }else{
      }
    })
  } */
  //this.initialize();
};
