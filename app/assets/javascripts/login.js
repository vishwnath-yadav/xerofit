//= require jquery

$(document).ready(function() {
  $('#txthdnPassword').hide();
  $(document).on('click','.spn_pass', function() {
      var isChecked = $(this).text();
      if(isChecked == "Show") {
          $('#user_password').hide();
          $('#txthdnPassword').show();
          $('.spn_pass').text("Hide");
          $('#txthdnPassword').val($('#user_password').val());
      }
      else {
          $('#user_password').show();
          $('#txthdnPassword').hide();
          $('.spn_pass').text("Show");
          $('#user_password').val($('#txthdnPassword').val());
      }
  });
});

