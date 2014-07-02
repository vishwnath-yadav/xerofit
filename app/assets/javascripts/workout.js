$( document ).ready(function() {
  $(document).on("click", ".wrk_out_form", function(){
     $(this).parent().html('<img src="/assets/ajax-loader.gif" class="ml">');
     $("#workout_form").submit();
  });
  $(".wrk_add_opt").fancybox();
  $(".close_icon").click(function(){
    $.fancybox.close();
  });

  $(".workout_submit").click(function(){
  	 name = $("input[name='radio']:checked").attr('id');
     split_name = name.split("_");
     title = $('.title').val();
  	 url = '/workouts/get_workout_sub_block';
	 $.get(url, {name:split_name[1],title:title}, function (data) {
	});
  });

  $('#publish').click(function(){
    $('#new_workout_form').submit();
  });
  var isRecycled = false;
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
    var size = parseInt($('.b'+id).text());
    if(size < 1){
      $("#block_"+id).find('.met_tab_desc ul').html('<li><span class="nummeric">1</span><h6>'+text+'</h6><p>30 seconds</p></li>');
    }
    else{
      $("#block_"+id).find('.met_tab_desc ul').append('<li><span class="nummeric">1</span><h6>'+text+'</h6><p>30 seconds</p></li>');
    }
    $('.b'+id).text(size + 1);
    var lib_id = element.split("_");
    alert(lib_id[1]);
    alert(id);
    $('#new_workout_form').append('<input type="hidden" name=workout["'+id+'"]["'+lib_id[1]+'"] value="'+lib_id[1]+'">');
}
