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
      		errorClass: 'error',
      		rules: {
      			"adopter[name]" : {
      				required: true,
      				maxlength: 50
      			},
      			"adopter[email]" : {
      				required: true,
      				email: true,
              remote: "/adopters/check_email"
      			},
      			"adopter[state]" : {
      				minlength: 2,
              maxlength: 2
      			},
      			"adopter[zip]" : {
      				digits: true,
      				minlength: 5,
      				maxlength: 5
      			},
                "adopter[references_attributes][0][email]" : {
                      required: false,
                      email: true    
                },
                "adopter[references_attributes][1][email]" : {
                      required: false,
                      email: true    
                },
                "adopter[references_attributes][2][email]" : {
                      required: false,
                      email: true    
                }
      		},
      		messages : {
      		  "adopter[email]" : {remote: "Email exists, contact adopt@ophrescue.org for changes." }
      		}
	 	}
	 });
});