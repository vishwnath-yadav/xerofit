$(document).ready(function() {

  $(window).scroll(function(){
    var sticky = $('.zheader-scroll'),
    scroll = $(window).scrollTop();

    if(scroll >= 70){
      $('.show-on-scroll').css('display','block');
    }
    else{
      $('.show-on-scroll').css('display','none');
    }
  });

  $(document).on('click','#enter-fullscreen', function(){
    $.smoothScroll({
      scrollElement: $('body'),
      scrollTarget: '#workout-builder-app'
    });
    $('body').addClass('disable-scroll');
    $('#enter-fullscreen').addClass('hide');
    $('#exit-fullscreen').removeClass('hide');
    return false;
  });

  $(document).on('click','#exit-fullscreen', function(){
    window.scrollTo(0, 0);
    //$('.show-on-scroll').css('display','none');
    $('body').removeClass('disable-scroll');
    $('#exit-fullscreen').addClass('hide');
    $('#enter-fullscreen').removeClass('hide');
  });

  $(document).on("click", ".wrk_out_form", function(){
     $(this).parent().html('<img src="/assets/ajax-loader.gif" class="ml">');
     $("#workout_form").submit();
  });



  $(document).on("click","#search-move-titles",function(){
    $('#filter_search_form').submit();
  });

  $(document).on("click",".search-bar-clear",function(e){
    $("#search-move-by-title").val('');
    $(".search-bar-clear").addClass('hide');
    $('.search-bar-icon').removeClass('hide');
    $('#search-move-by-title').css({
      'padding-left': '30px',
      'text-align': 'center',
      'color': '#CCCCCC'
    });
    $('#filter_search_form').submit();
  });

  $(document).on("keyup, mouseup", '#search-move-by-title', function(e){
      if(e.which == 13){//Enter key pressed
        $('#filter_search_form').submit();
      }
  });

  $(document).on("focus", '#search-move-by-title', function(){
    $(this).css('text-align', 'left');
    $(".search-bar-clear").removeClass('hide');
    $('.search-bar-icon ').addClass('hide');
    $(this).css({
      'padding-left': '12px',
      'color': '#4C4D4E',
    });
  });

  $(document).on("blur", '#search-move-by-title', function(){
    var inputText = $.trim($(this).val());

    if(inputText.length>0)
    {
      return false;
    } else {
      $(this).css('text-align', 'center');
      $('.search-bar-clear').addClass('hide');
      $('.search-bar-icon').removeClass('hide');
      $(this).css('padding-left', '30px');
    }
  });

  $('#search-move-by-title').bind('railsAutocomplete.select', function(event, data){
    $('#filter_search_form').submit();
  });



  $(document).on("click",".wrk_add_opt", function(){
    $.fancybox.open({
      href: '#wrk_add_option',
      type: 'inline'
    });
  });

  $(document).on("click",".close_icon", function(){
    $.fancybox.close();
  });

  $(document).on('click','#publish', function(){
    var verify = true;
    if(!$('#workid').length){
      verify = false;
      alert("Please fill workout details.");
    }
    else if($('.met_tab_desc').length <= 1){
      verify = false;
      alert("Please create sub blocks.");
    }
    else{
      $('.met_tab_desc').each(function(){
        if(!$(this).closest('.block_hide').length){
          var b_id = $(this).find('#block_id').val();
          var b_type = $('#block_type_'+b_id).val();
          var li_size = $(this).find('ul li.block_li').size();
          var check = check_library_publish(li_size, b_type)
          if(check != ''){
            verify = false;
            alert(check);
            return false;
          }
        }
      });
    }
    if(verify){
      $('#new_workout_form').submit();
    }
  });


  $(document).on('click','.close-panel', function(){
    $('.li_active').removeClass('li_active');
    $("#move-details-panel").css('display', 'none');
  });

  $(document).on("click",".met_tab_desc ul li", function(e){
    if($(e.target).hasClass("rm")){
      var hiden_field_id = $(this).attr('id');
      var main_block_id = hiden_field_id.split('_')[0];
      $("#block_"+hiden_field_id).remove();
      $('#block_'+main_block_id).remove();
      remove_library_from_block(hiden_field_id);
      $(this).remove();
    }
    else{
      $('.li_active').removeClass('li_active');
      $(this).addClass('li_active');
      var lib_id = $(this).attr('id').split("_")[1];
      var block_id = $(this).attr('id').split("_")[0];
      var lib_detail = $(this).attr('data-libdetail');
      load_library_content(lib_detail, block_id, lib_id, '');
    }
  });

  // Dropdown
  $(document).on('change', ".lib_detail_sel", function(){
    $(".edit_move_detail").submit();
  });

  $(document).on('click', ".lib_detail_chk", function(){
    $(".edit_move_detail").submit();
  });

  $(document).on('blur', ".lib_detail_inp", function(){
    var $input = $(this).find('input');
    var val = parseInt($input.val());
    var max = parseInt($input.attr('max'));
    var min = parseInt($input.attr('min'));
    if(val > max || val < min){
      // $('.success').addClass('move_detail').text('number must be between '+min+' and '+max)
      $input.css('border','1px solid red');
      $input.val(min);
      alert('number must be between '+min+' and '+max);
      setTimeout(function(){$input.css('border','none')}, 3000);
    }
    else{
      $(".edit_move_detail").submit();
    }
  });

  $(document).on('click', ".met_head", function(){
    $(this).siblings().toggle('slow');
    $(this).find('.tab_arrow').toggleClass('right_arow', 500);
  });

  $(document).on('click', ".wrk_head,.wrk_subhead", function(){
    if($('.workout_auto_input').length < 1){
      $( ".workout_auto_input").focus();
      var name = $(this).attr('data-name');
      var text = $(this).attr('data-val');
      $(this).hide();
      $(this).after('<p><input type=text name=workout['+name+'] id=auto_form_field class="workout_auto_input blur_input" value='+text+'></p>');
      $('.workout_auto_input').focus();
    }
  });

  $(document).on('blur', ".blur_input", function(){
    var txt = $(this).val();
    var name = $(this).attr('name');
    if(txt == '' && name.indexOf('name') > -1){
      alert("Title Can't be blank");    
    }
    else if(name.indexOf('subtitle') > -1 && $('.wrk_head').text() == "Workout Title"){
      alert("Title Can't be blank");    
      $('.wrk_subhead').show();
      $(this).parent().remove();
    }
    else{
      $("#workout_form_auto").submit();
    }
  });

  $(document).on('mouseover','.fetured_li ul li', function(){
    $('.active_tab').removeClass('active_tab');
    $(this).addClass('active_tab');
  });

  $(document).on('keyup',"#workout_form input, textarea", function(){
    var obj = $(this).closest('.form_field').find('span.detail_char');
    var max_size = parseInt(obj.attr('data-size'));
    var size = $(this).val().length;
    obj.text(size+'/'+max_size+' Character');
  });

  $(document).on('click',".block_type_submit", function(){
     create_sub_block();
  });

  $(document).on('keyup','.sub_block_title_input',function(e){
    if(e.keyCode == 13){
      create_sub_block();
      return false;
    }
  });
});

// $(document).on('page:load', ready);

function remove_library_from_block(id){
  url = '/builder/remove_library_from_block';
  $.get(url, {lib_block:id}, function (data) {
  });
}

function create_sub_block(){
  var type = $("input[name='radio']:checked").attr('id');
  type = type.split("_")[1];
  var title = $('.title').val();
  sub_block_ajax(type, title, '');
}

function create_individual_sub_block(){
  $('.drag_img').remove();
  sub_block_ajax();
}

function sub_block_ajax(){
  url = '/builder/get_workout_sub_block';
  $.get(url, {}, function (data) {
  });
}

function remove_msg(){
  $('.success').removeClass('move_detail').html('');
}

function drag_over(e) {
    e.dataTransfer.dropEffect='move';
    e.dataTransfer.setData("text/plain", e.target.getAttribute('id'));
}

function drag_start(e) {
    e.dataTransfer.dropEffect='move';
    e.dataTransfer.setData("text/plain", e.target.getAttribute('id'));
}

function drag_drop(e, id) {
    var element = e.dataTransfer.getData("Text");
    var text = $("#"+element).find('h6').text();
    var dragable_type = $("#"+element).attr('data-dragable-type');
    if(dragable_type == "Block"){
      if($('#block_'+id).find('.block_hide').length){
        var block_name = $("#"+element).attr('data-block-name');
        initialize_new_block(id, block_name);
      }
    }
    else{
      var block_type = $('#block_type_'+id).val();
      if(block_type != ''){
        manage_drop_library_into_block(id, block_type, element, text);
      }
      else{
        manage_drop_library_directly(id, block_type, element, text); 
      }
    }
}

function initialize_new_block(id, block_name){
  $('.block_hide').removeClass('block_hide');
  $("#block_type_"+id).val(block_name);
  $("#block_type_h4_"+id).text(block_name);
  create_individual_sub_block();
}

function manage_drop_library_into_block(id, block_type, element, text){
  var li_size = $("#block_"+id).find('.met_tab_desc ul li.block_li').size();
  var check = check_library_count(li_size, block_type);
  var lib_id = element.split("_")[1];
  if(check != ''){
    alert(check);
  }
  else if (check_library_present(lib_id, id)){
    alert("Library Already Exists");
  }
  else{
    $("#block_"+id).find('.met_tab_desc ul').append('<li id='+id+'_'+lib_id+' class="block_li"><span class="rm" id=rm_'+id+'_'+lib_id+'></span><h6>'+text+'</h6></li>');
    load_library_content('',id, lib_id, '');
    $('#new_workout_form .hidden_field_workout').append('<input type=hidden name=workout['+id+']['+lib_id+'] id=block_'+id+'_'+lib_id+' value='+lib_id+'>');
  }
}

function manage_drop_library_directly(id, block_type, element, text){
  $('#block_'+id).find('.met_tab_col').addClass('single_move_drop');
  $('#block_'+id).find('.met_tab_desc li:eq(0)').remove();
  $('#block_'+id).find('.met_head').remove();
  initialize_new_block(id, BLOCK_TYPE[3]);
  manage_drop_library_into_block(id, block_type, element, text);
}

function individual_block_show(id){
  if($("#block_"+id).find('.block_hide').length){
    $('.block_hide').removeClass('block_hide');
    create_individual_sub_block();
  }
}

function check_library_count(li_size, block_type){
  var alrt = "";
  if((block_type == BLOCK_TYPE[1])&&(li_size == 2)){
      alrt = BLOCK_TYPE[1]+" Block must have exactly 2 libraries.";
  }
  else if((block_type == BLOCK_TYPE[3])&&(li_size>0)){
   alrt = BLOCK_TYPE[3]+" Block must have exactly 1 library";
  }
  return alrt;
}

function load_library_content(lib_detail_id, block_id, lib_id, move){
  if(lib_detail_id != ''){
    $("#move-details-panel").css('display', 'block');
    $("#move-details-panel").html('<img src="/assets/ajax-loader.gif" class="m50">');
  }
  var url = '/builder/load_lib_details';
  $.get(url, {lib_detail_id:lib_detail_id,lib_id:lib_id,block_id:block_id, move:move}, function (data) {
   });
}

function check_library_publish(li_size, block_type){
  var alrt = "";
  if((block_type == BLOCK_TYPE[1])&&(li_size<2)){
    alrt = BLOCK_TYPE[1]+" Block must have exactly 2 libraries.";
  }
  else if((block_type == BLOCK_TYPE[2])&&(li_size<1)){
   alrt = BLOCK_TYPE[2]+" Block must have exactly 1 library";
  }
  else if(block_type == BLOCK_TYPE[0] && li_size<3){
    alrt = BLOCK_TYPE[0]+" Block must have minimum 3 library";
  }
  return alrt;
}

function check_library_present(lib_id, id){
  var present = false;
  $("#block_"+id).find(".met_tab_desc ul li").each(function(){
    if($(this).attr('id')){
      lid = $(this).attr('id').split("_")[1];
      if(lid == lib_id){
        present = true;
        return false
      }
    }
  });
  return present;
}

function sort_lis(obj){
  $(obj).parent().find('li').each(function(i, val){
    $(this).find('.nummeric').text(i + 1);
  });
}

function show_text_size(){
  $('.detail_char').each(function(){
    var size = $(this).attr('data-size');
    
    var input_len = $(this).closest('.form_field').find('input, textarea').val().length;
      $(this).text(input_len+' of '+ size+' Character');
  })
}
