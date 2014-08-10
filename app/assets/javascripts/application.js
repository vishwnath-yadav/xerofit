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
//= require autocomplete-rails
//= require turbolinks


//= require plugins/bootstrap.min
//= require plugins/bootstrap-progressbar.min
//= require plugins/dropzone.min
//= require plugins/jquery.fancybox.js
//= require plugins/jquery_form.js

//= require helpers/resource_constants.js
//= require helpers/video_upload.js

//= require pages/library.js
//= require pages/workout.js


$( document ).ready(function() {

    $(window).scroll(function(){
      var sticky = $('.lib_img_coll'),
      scroll = $(window).scrollTop();

      if(scroll >= 100){
        sticky.addClass('fixed');
        $('.show_img_on_scol').css('display','block');
      }
      else{
       sticky.removeClass('fixed');
       $('.show_img_on_scol').css('display','none');
     }
    });

    $('.global_nav_toggle').dropdown();
    $('.notification_menu_toggle').dropdown();
    $('.utility_menu_toggle').dropdown();


  // $(document).on("click", ".fancy_input", function() {
  //   $('.mus_select').remove();
  //   var number_of_select = $(this).val();
  //   $('.active').removeClass('active');
  //   $(this).addClass('active');
  //   var i=0;
  //   var target = ['Primary Target', 'Second Target', 'Thired Target', 'Fouth Target', 'Fifth Target']
  //   var option = ['body', 'sholder', 'arms']
  //   for(i=0; i<number_of_select; i++)
  //   {
  //   var select = "<select name='library[target_muscle_groups_attributes]["+i+"][target_muscle_group]'><option value='body'>Body</option> <option value='sholder'>Sholder</option> <option value='arms'>Arms</option></select>";
  //   var form_create = "<div class='exr_field_col mus_select'><label>"+target[i]+"</label><div class='fancy_select'>"+select+"</div></div>";
  //   $('.mus_count').after(form_create);
  //   }
  // });

  $(document).on("click", ".fancy_input", function() {
     var select_count = $(this).val();
     len = $('.edit_tmg:visible').length;
     $('.active').removeClass('active');
     lib_id = $('#lib_id').attr('id');
     $(this).addClass('active');
     
     if((len<select_count)||(len>select_count)){
      $('.chg_save').removeClass('dis_link');
     }

     if(len<=select_count){
       for(i=0;i<select_count;i++){
         $(".edit_tmg:eq("+i+")").css('display','block');
       }
     }
     else
     {
        for(i=4;i>=select_count;i--){
         $(".edit_tmg:eq("+i+")").css('display','none');
         $(".drop_toggle:eq("+i+")").text("Choose "+MUSCLES_TYPE[i]);
         $(".taget_val:eq("+i+")").val("");
         $(".taget_sub_val:eq("+i+")").val("");
        }
        $('.chg_save').removeClass('dis_link');
     }
  });


  $('.edit_lib').click(function(){
    var status = $(this).attr('lib-status');
    $('#status').val(status);
    $('#edit_video_info').submit();
  });

  $('#panda_video_enable').click(function(){
    $('#video_library_info').submit();
  });

  $('.li_active').click(function() {
    $('.li_active').removeClass('active');
    $(this).addClass('active');
  });

  $(".choose_btn").click(function(){
     $(this).css('background', '#72c9b8');
     $("#user_pic").click();
  });

  $(".wrk_chos").click(function(){
     $(this).css('background', '#72c9b8');
     $("#workout_pic").click();
  });

  $('.custom-upload input[type=file]').change(function(e){
    $('.wrk_sve').removeClass('dis_link');
    var file = e.target.files[0].name;
    $(this).next().find('input').val(file);
  });

  $('#country_select').on("change", function() {
    select_wrapper = $('#order_state_code_wrapper')

    $('select', select_wrapper).attr('disabled', true)
    country_code = $(this).val();
    url = "/subregion_options?parent_region=" +country_code
    select_wrapper.load(url)
  });

  setTimeout(load_dropKick_js, 5000);

});

function load_dropKick_js() {
  $('.status_select ul li').click(function(){
    $('#status').val($(this).text());
    $('#search_grid_list_form').submit();
  });

  $('.type_select ul li').click(function(){
    $('#type').val($(this).text());
    $('#search_grid_list_form').submit();
  });
}

