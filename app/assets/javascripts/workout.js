$( document ).ready(function() {
  $(document).on("click", ".wrk_out_form", function(){
     $(this).parent().html('<img src="/assets/ajax-loader.gif" class="ml">');
     $("#workout_form").submit();
  });

  $(document).on("click", "#filter_change", function(){
    var lib_id = [];
    $('.library_list .white_list').each(function(){
      lib_id.push($(this).attr('id').split("_")[1]);
    });
    
    var filter_cls = $(this).attr("class");
    url = '/workouts/filter';
    $(this).toggleClass('asc', 500);
    var type = $(this).hasClass("asc") ? 'asc' : 'desc';
    $.get(url, {order:type, lib_list:lib_id}, function (data) {
     });
  });

  $(".workout_search_btn").click( function(){
    var search_txt = $(".search_icon").val();
    var type = $("#filter_change").hasClass("asc") ? 'asc' : 'desc';
    url = '/workouts/search_lib';
    $.get(url, {search_value:search_txt, order:type}, function (data) {
    });
  });
  $('.search_icon').keypress(function(e){
      if(e.which == 13){//Enter key pressed
        $('.workout_search_btn').click();//Trigger search button click event
      }
  });


  $(".wrk_add_opt").click(function(){
    var name = $('#workout_id').val();
    if(name){
      $.fancybox.open({
            href: '#wrk_add_option',
            type: 'inline'
        });
    }
    else   {
      alert("Please fill workout details");
    }

  });

  $(".close_icon").click(function(){
    $.fancybox.close();
  });

  $('#publish').click(function(){
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
          var b_type = $(this).find('#block_type_'+b_id).val();
          var li_size = $(this).find('ul li').size();
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
  
  $(document).on("click",".met_tab_desc ul li", function(e){
    if($(e.target).hasClass("rm")){
      var id = $(this).attr('id');
      $("#block_"+id).remove();
      remove_library_from_block(id)
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

  $(document).on('change', ".lib_detail_sel", function(){
    $(".edit_library_detail").submit();
  });

  $(document).on('click', ".lib_detail_chk", function(){
    $(".edit_library_detail").submit();
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
      $(".edit_library_detail").submit();
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

  $('.edit_work').click(function(){
    var status = $(this).attr('lib-status');
    $('.workout_status').val(status);
    $('#edit_workout_info').submit();
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

  $('.fetured_li ul li').mouseover(function(){
    $('.active_tab').removeClass('active_tab');
    $(this).addClass('active_tab');
  });

  $(document).on('keyup',"#workout_form input, textarea", function(){
    var obj = $(this).closest('.form_field').find('span.detail_char');
    var max_size = parseInt(obj.attr('data-size'));
    var size = $(this).val().length;
    obj.text(size+'/'+max_size+' Character');
  });

  $(".block_type_submit").click(function(){
     create_sub_block();
  });

  $(document).on('keyup','.sub_block_title_input',function(e){
    if(e.keyCode == 13){
      create_sub_block();
      return false;
    }
  });
});

function remove_library_from_block(id){
  url = '/workouts/remove_library_from_block';
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
  var type = BLOCK_TYPE[2];
  var title = 'Individual';
  sub_block_ajax(type, title, 'block_hide');
}

function sub_block_ajax(type, title, display){

  if(title){
    url = '/workouts/get_workout_sub_block';
    $.get(url, {type:type,title:title,display:display}, function (data) {
    });
  }
  else{
    $('.title').css('border-color','red');
  }
}

function remove_msg(){
  $('.success').removeClass('move_detail').html('');
}

function drag_start(e) {
    e.dataTransfer.dropEffect='move';
    e.dataTransfer.setData("text/plain", e.target.getAttribute('id'));
}

function drag_drop(e, id) {
    var element = e.dataTransfer.getData("Text");
    var text = document.getElementById(element).innerHTML;
    var lib_id = element.split("_")[1];
    var size = parseInt($('.b'+id).text()) + 1;
    $('.li_active').removeClass('li_active');
    var block_type = $('#block_type_'+id).val();
    var li_size = $("#block_"+id).find('.met_tab_desc ul li').size();
    var check = check_library_count(li_size, block_type, false);
    if(!$('#workid').length){
      alert("Please fill workout details.")
    }
    else if(check != ''){
      alert(check);
    }
    else if (check_library_present(lib_id, id)){
          alert("Library Already Exists");
      }
      else{
          individual_block_show(id);
          $("#block_"+id).find('.met_tab_desc ul').append('<li id='+id+'_'+lib_id+' class=li_active><span class="rm" id=rm_'+id+'_'+lib_id+'>X</span><span class="nummeric" data-libdetail="">'+size+'</span><h6>'+text+'</h6></li>');
          $('.b'+id).text(size);
          load_library_content('',id, lib_id, size);
          $('#new_workout_form .hidden_field_workout').append('<input type=hidden name=workout['+id+']['+lib_id+'] id=block_'+id+'_'+lib_id+' value='+lib_id+'>');
      }
      $('.dots_img').remove() //removing all dots from dropped lis
}

function individual_block_show(id){
  if($('.drag_img').length){
    $('.drag_img').remove();
  }
  $('#block_'+id).removeClass('block_hide');
  if(!$('.block_hide').length){
    create_individual_sub_block();
  }
}

function check_library_count(li_size, block_type, publish){
  var alrt = "";
  if((block_type == BLOCK_TYPE[1])&&(li_size == 2)){
      alrt = BLOCK_TYPE[1]+" Block must have exactly 2 libraries.";
  }
  else if((block_type == BLOCK_TYPE[2])&&(li_size>0)){
   alrt = BLOCK_TYPE[2]+" Block must have exactly 1 library";
  }
  return alrt;
}

function load_library_content(lib_detail, block_id, lib_id, move){
  $(".workout_col_rght").html('<img src="/assets/ajax-loader.gif" class="m50">');
  var url = '/workouts/load_lib_details'
  $.get(url, {lib_detail:lib_detail,lib_id:lib_id,block_id:block_id, move:move}, function (data) {
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
    lid = $(this).attr('id').split("_")[1];
    if(lid == lib_id){
      present = true;
      return false
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
