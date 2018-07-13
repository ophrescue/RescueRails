//  ref: https://github.com/jquery/sizzle/pull/413
$(function() {
  $.expr[":"].valid = function(elem) {
    if($(elem).is('form')){
      // extend the :valid pseudo class to forms
      return ($(elem).find(':input:invalid').length == 0)
    }else{
      return elem.validity !== undefined && elem.validity.valid === true;
    }
  }

  $.expr[":"].invalid = function(elem) {
    // Both `invaild` and `valid` return false if elem has no `validity` attribute
    if($(elem).is('form')){
      // extend the :invalid pseudo class to forms
      return ($(elem).find(':input:invalid').length > 0)
    }else{
      return elem.validity !== undefined && elem.validity.valid === false;
    }
  }

  $.expr[":"].hasConstraints = function(elem){
    return !(_.isUndefined($(elem).attr('required')) && _.isUndefined($(elem).attr('pattern')) && _.isUndefined($(elem).attr('maxLength')))
  }

  $.expr[":"].valueMissing = function(elem){
    return elem.validity !== undefined && elem.validity.valueMissing === true;
  }

  $.expr[":"].tooLong = function(elem){
    return elem.validity !== undefined && elem.validity.tooLong === true;
  }

  $.expr[":"].patternMismatch = function(elem){
    return elem.validity !== undefined && elem.validity.patternMismatch === true;
  }
})
