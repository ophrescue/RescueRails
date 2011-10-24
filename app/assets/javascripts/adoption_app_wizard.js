$(function(){
	$("#new_adopter").formwizard({ 
	 	formPluginEnabled: true,
	 	focusFirstInput : true,
	 	historyEnabled : true,
	 	validationEnabled: false,
	 	formOptions :{
			success: function(data){$("#status").fadeTo(500,1,function(){ $(this).html("You are now registered!").fadeTo(5000, 0); })},
			beforeSubmit: function(data){$("#data").html("data sent to the server: " + $.param(data));},
			dataType: 'json',
			resetForm: true
	 	}	
	 }
	);
});