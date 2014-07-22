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
//= require_tree .


$( document ).ready(function() {
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

  $('.custom-upload input[type=file]').change(function(){
    $(this).next().find('input').val($(this).val());
  });

  $('#country_select').on("change", function() {
    select_wrapper = $('#order_state_code_wrapper')

    $('select', select_wrapper).attr('disabled', true)
    country_code = $(this).val();
    url = "/subregion_options?parent_region=" +country_code
    select_wrapper.load(url)
  });
});

