//= require jquery
//= require jquery.detect_timezone
//= require browser_timezone_rails/application.js

$(document).ready(function() {
  $('#txthdnPassword').hide();
  $(document).on('click','.toggle-pass', function() {
      var isChecked = $(this).text();
      if(isChecked == "Show") {
          $('#user_password').hide();
          $('#txthdnPassword').show();
          $('.toggle-pass').text("Hide");
          $('#txthdnPassword').val($('#user_password').val());
      }
      else {
          $('#user_password').show();
          $('#txthdnPassword').hide();
          $('.toggle-pass').text("Show");
          $('#user_password').val($('#txthdnPassword').val());
      }
  });
  $(document).on("blur","#user_email",function () {
    var tz = jstz.determine();
    var zone_name = tz.name();
    $(".time_zone").val(zone_name);
  })
});

