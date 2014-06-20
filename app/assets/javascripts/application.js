// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require turbolinks
//= require_tree .


$( document ).ready(function() {
  // $(".fancy_input").unbind();
  $(document).on("click", ".fancy_input", function() {
   
    $('.del').remove();
    var number_of_select = $(this).val();
    var i=0;
    var target = ['Primary Target', 'Second Target', 'Thired Target', 'Fouth Target', 'Fifth Target']
    var option = ['one', 'two', 'three']
    for(i=0; i<number_of_select; i++)
    {
    
    var select = "<select name='library[target_muscle_groups_attributes]["+i+"][target_muscle_group]'><option value='one'>One</option> <option value='two'>Two</option> <option value='three'>Three</option></select>";


    var form_create = "<div class='exr_field_col del'><label>"+target[i]+"</label><div class='fancy_select'>"+select+"</div></div>";
    $('.exer_rht_col').append(form_create);
    }

    // $.ajax({
    //   type: 'GET',
    //   url: '/target_muscle_group?val=' + number_of_select
    // });
    
  });


  

  // $('#video_upload_form').on('change', function() {
  //   $(this).submit();
  // });

  // $('.sort_select').on('change', function(){
  //   alert($(this).val());
  //   var v= $(this).val();
  //  $.ajax({
  //   type: "GET",
  //   url: "/sort_video?val=" + v
  //  });
  // });

});

