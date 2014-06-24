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
    $('.active').removeClass('active');
    $(this).addClass('active');
    var i=0;
    var target = ['Primary Target', 'Second Target', 'Thired Target', 'Fouth Target', 'Fifth Target']
    var option = ['body', 'sholder', 'arms']
    for(i=0; i<number_of_select; i++)
    {
    
    var select = "<select name='library[target_muscle_groups_attributes]["+i+"][target_muscle_group]'><option value='body'>Body</option> <option value='sholder'>Sholder</option> <option value='arms'>Arms</option></select>";


    var form_create = "<div class='exr_field_col del'><label>"+target[i]+"</label><div class='fancy_select'>"+select+"</div></div>";
    $('.exer_rht_col').append(form_create);
    }
  });

  // $('.image_url').click(function(){
  //   alert($(this).val());

  // })

  $('.li_class').click(function(){

    $('.li_change').removeClass('li_change');
    $(this).addClass('li_change');

  })
  
  $('.load_more').click(function(){
   
    $('.image_hide').each(function( index ) {
      
      if(index<3)
      {
        $(this).removeClass('image_hide');
        
      }


      if($('.image_hide').size() == 0)
      {
        $('.load_more').hide();
      }
      // else
      // {
      //   return true;
      //   alert("345")
      // }

    });
  });

  // $('.thumbnail_col ul').hide();
    

  
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

