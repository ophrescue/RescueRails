// use in conjunction with Bootstrap validation
// this requires the file input field to have a data attribute:
// (in html) data-max_size=10 or alternatively in erb data:{max_size: 10}
// notes:
//   1. requires file input to have mime-types and max-size data attributes
//   2. data attribute has dash ("kebab case"), but it is interpreted by jQuery as camelCase
//   3. size is specified in megabytes
var upload_file_validator = function(event){
  var $file_field = $(event.target);
  var max_size = parseInt($file_field.data('maxSize'))*1024*1024;
  var mime_types = $file_field.data('mimeTypes')
  if(typeof this.files[0] != 'undefined'){
    var file = this.files[0];
    var file_size = file.size;
    var file_type = file.type;
    var too_big = file_size > max_size;
    var wrong_type = mime_types.indexOf(file_type) == -1
    if(too_big || wrong_type){
      this.setCustomValidity("some text any text it doesn't matter, the message is specified in the html")
    }else{
      this.setCustomValidity('')
    }
  }
};
