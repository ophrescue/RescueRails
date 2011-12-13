jQuery(function($){
	$('#event_start_datetime').datetimepicker({
		ampm: true,
	    onClose: function(dateText, inst) {
	        var endDateTextBox = $('#example16_end');
	        if (endDateTextBox.val() != '') {
	            var testStartDate = new Date(dateText);
	            var testEndDate = new Date(endDateTextBox.val());
	            if (testStartDate > testEndDate)
	                endDateTextBox.val(dateText);
	        }
	        else {
	            endDateTextBox.val(dateText);
	        }
	    },
	    onSelect: function (selectedDateTime){
	        var start = $(this).datetimepicker('getDate');
	        $('#event_end_datetime').datetimepicker('option', 'minDate', new Date(start.getTime()));
	    }
	});
	$('#event_end_datetime').datetimepicker({
		ampm: true,
	    onClose: function(dateText, inst) {
	        var startDateTextBox = $('#event_start_datetime');
	        if (startDateTextBox.val() != '') {
	            var testStartDate = new Date(startDateTextBox.val());
	            var testEndDate = new Date(dateText);
	            if (testStartDate > testEndDate)
	                startDateTextBox.val(dateText);
	        }
	        else {
	            startDateTextBox.val(dateText);
	        }
	    },
	    onSelect: function (selectedDateTime){
	        var end = $(this).datetimepicker('getDate');
	        $('#event_start_datetime').datetimepicker('option', 'maxDate', new Date(end.getTime()) );
	    }
	});

});