$( document ).ready(function() {
  $(document).on("click", ".wrk_out_form", function(){
     $(this).parent().html('<img src="/assets/ajax-loader.gif" class="ml">');
     $("#workout_form").submit();
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

  $(".block_type_submit").click(function(){
  	 type = $("input[name='radio']:checked").attr('id');
     type = type.split("_")[1];
     title = $('.title').val();
     if(title){
  	   url = '/workouts/get_workout_sub_block';
	     $.get(url, {type:type,title:title}, function (data) {
	     });
     }
    else{
      $('.title').css('border-color','red');
    }
  });

  $('#publish').click(function(){
    var verify = false;
    $('.met_tab_desc').each(function(){
      var b_id = $(this).find('#block_id').val();
      var b_type = $(this).find('#block_type_'+b_id).val();
      var li_size = $(this).find('ul li').size();
      var check = check_library_publish(li_size, b_type)
      if(check != ''){
        verify = true;
        alert(check);
        return false;
      }
    });
    if(verify == false){
      $('#new_workout_form').submit();
    }
  });
  
  $(document).on("click",".met_tab_desc ul li", function(e){
    if($(e.target).hasClass("rm")){
      var id = $(this).attr('id');
      $("#block_"+id).remove();
      $(this).remove();
    }
    else{
      $('.li_active').removeClass('li_active');
      $(this).addClass('li_active');
      var lib_id = $(this).attr('id').split("_")[1];
      var block_id = $(this).attr('id').split("_")[0];
      var lib_detail = $(this).attr('data-libdetail');
      load_library_content(lib_detail, block_id, lib_id);
    }
  });

  $(document).on('change', ".lib_detail_sel", function(){
      $(".edit_library_detail").submit();
  });

  $(document).on('click', ".lib_detail_chk", function(){
    $(".edit_library_detail").submit();
  });

  $(document).on('click', ".met_head", function(){
    $(this).siblings().toggle('slow');
    $(this).find('.tab_arrow').toggleClass('right_arow', 500);
  });

  $(document).on('click', ".wrk_head,.wrk_subhead", function(){
    if($('.workout_auto_input').length < 1){
      $( ".workout_auto_input").focus();
      var name = $(this).attr('data-name');
      $(this).hide();
      $(this).after('<p><input type=text name=workout['+name+'] id=auto_form_field class="workout_auto_input blur_input"></p>');
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

  $('.fetured_li ul li').mouseover(function(){
    $('.active_tab').removeClass('active_tab');
    $(this).addClass('active_tab');
  });
});

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
    if(check != ''){
      alert(check);
    }
    else if (check_library_present(lib_id, id)){
          alert("Library Already Exists");
      }
      else{
          $("#block_"+id).find('.met_tab_desc ul').append('<li id='+id+'_'+lib_id+' class=li_active><span class="rm" id=rm_'+id+'_'+lib_id+'>X</span><span class="nummeric" data-libdetail="">'+size+'</span><h6>'+text+'</h6></li>');
          $('.b'+id).text(size);
          load_library_content('',id, lib_id);
          $('#new_workout_form .hidden_field_workout').append('<input type=hidden name=workout['+id+']['+lib_id+'] id=block_'+id+'_'+lib_id+' value='+lib_id+'>');
      }
      $('.dots_img').remove() //removing all dots from dropped lis
}

function check_library_count(li_size, block_type, publish){
  var alrt = "";
  if((block_type == "superset")&&(li_size == 2)){
      alrt = "Superset Block must have exactly 2 libraries.";
  }
  else if((block_type == "individual")&&(li_size>0)){
   alrt = "Individual Block must have exactly 1 library";
  }
  return alrt;
}

function load_library_content(lib_detail, block_id, lib_id){
  $(".workout_col_rght").html('<img src="/assets/ajax-loader.gif" class="m50">');
  var url = '/workouts/load_lib_details'
  $.get(url, {lib_detail:lib_detail,lib_id:lib_id,block_id:block_id}, function (data) {
   });
}

function check_library_publish(li_size, block_type){
  var alrt = "";
  if((block_type == "superset")&&(li_size<2)){
    alrt = "Superset Block must have exactly 2 libraries.";
  }
  else if((block_type == "individual")&&(li_size<1)){
   alrt = "Individual Block must have exactly 1 library";
  }
  else if(block_type == "circuit" && li_size<3){
    alrt = "Circuit Block must have minimum 3 library";
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
