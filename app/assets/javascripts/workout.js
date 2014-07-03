$( document ).ready(function() {
  $(document).on("click", ".wrk_out_form", function(){
     $(this).parent().html('<img src="/assets/ajax-loader.gif" class="ml">');
     $("#workout_form").submit();
  });
  $(".wrk_add_opt").fancybox();
  $(".close_icon").click(function(){
    $.fancybox.close();
  });

  $(".block_type_submit").click(function(){
  	 type = $("input[name='radio']:checked").attr('id');
     type = type.split("_")[1];
     title = $('.title').val();
  	 url = '/workouts/get_workout_sub_block';
	 $.get(url, {type:type,title:title}, function (data) {
	 });
  });

  $('#publish').click(function(){
    $('#new_workout_form').submit();
  });
  
  $(".met_head").click(function(){
    $(this).find(".met_tab_desc ul").toggle('slow');
  });

  $(document).on("click",".met_tab_desc ul li", function(){
    $('.li_active').removeClass('li_active');
    $(this).addClass('li_active');
    var lib_id = $(this).attr('id').split("_")[1];
    var block_id = $(this).attr('id').split("_")[0];
    var lib_detail = $(this).attr('data-libdetail');
    load_library_content(lib_detail, block_id, lib_id);
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
  $('.b'+id).text(size + 1);
  var lib_id = element.split("_")[1];
  var size = parseInt($('.b'+id).text());
  $('.li_active').removeClass('li_active');
  if(size < 1){
    $("#block_"+id).find('.met_tab_desc ul').html('<li id='+id+'_'+lib_id+' class=li_active><span class="nummeric" data-libdetail="">1</span><h6>'+text+'</h6><p>30 seconds</p></li>');
  }
  else{
    $("#block_"+id).find('.met_tab_desc ul').append('<li id='+id+'_'+lib_id+' class=li_active><span class="nummeric" data-libdetail="">1</span><h6>'+text+'</h6><p>30 seconds</p></li>');
  }
  load_library_content('',id, lib_id);
  $('#new_workout_form').append('<input type=hidden name=workout['+id+']['+lib_id+'] id=block_'+id+'_'+lib_id+' value='+lib_id+'>');
}

function load_library_content(lib_detail, block_id, lib_id){
  $(".workout_col_rght").html('<img src="/assets/ajax-loader.gif" class="m50">');
  var url = '/workouts/load_lib_details'
  $.get(url, {lib_detail:lib_detail,lib_id:lib_id,block_id:block_id}, function (data) {
   });
}
