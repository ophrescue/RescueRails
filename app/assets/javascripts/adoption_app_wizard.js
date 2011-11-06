$(function(){
	$("#new_adopter").formwizard({ 
	 	focusFirstInput : true,
	 	historyEnabled : true,
	 	validationEnabled: true,
	 	disableUIStyles : true,
		inDuration : 200,
		outDuration: 200,
		validationOptions : {
			highlight: function(element, errorClass, validClass) {
	     $(element).parents("div[class='clearfix']").addClass('error').removeClass(validClass);
	  	},
      unhighlight: function (element, errorClass, validClass) { 
        $(element).parents(".error").removeClass('error'); 
      },
      errorElement: 'span',
      errorClass: 'help-inline'
	 	}
	 });
});