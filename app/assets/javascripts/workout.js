$( document ).ready(function() {
  $(document).on("click", ".wrk_out_form", function(){
     $(this).parent().html('<img src="/assets/ajax-loader.gif" class="ml">');
     $("#workout_form").submit();
  });
  $(".wrk_add_opt").fancybox();
  $(".close_icon").click(function(){
    $.fancybox.close();
  });

  $(".block_type").click(function(){
  	 name = $(this).attr('id');
  	 url = '/workouts/get_workout_sub_block';
	 $.get(url, {name:name}, function (data) {
	});
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

function drag_drop(e) {
    var element = e.dataTransfer.getData("Text");
    //alert(element);
    var text = document.getElementById(element).innerHTML;
    var size = parseInt($('.b1').text());
    if(size < 1){
      $("#drop_div").find('.met_tab_desc ul').html('<li><span class="nummeric">1</span><h6>'+text+'</h6><p>30 seconds</p></li>');
    }
    else{
      $("#drop_div").find('.met_tab_desc ul').append('<li><span class="nummeric">1</span><h6>'+text+'</h6><p>30 seconds</p></li>');
    }
    $('.b1').text(size + 1)
}
