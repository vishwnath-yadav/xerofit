$( document ).ready(function() {
  $(document).on("click", ".wrk_out_form", function(){
     $(this).parent().html('<img src="/assets/ajax-loader.gif" class="ml">');
     $("#workout_form").submit();
  });

  $(".wrk_add_opt").click(function(){
    var name=$('#workout_id').val();
    if(name)
    {
      $.fancybox.open({
            href: '#wrk_add_option',
            type: 'inline'

        });
    }
    else
    {
      alert("Please fill workout details");
    }

  });

  // $(".wrk_add_opt").fancybox();
  $(".close_icon").click(function(){
    $.fancybox.close();
  });

  $(".block_type_submit").click(function(){

  	 type = $("input[name='radio']:checked").attr('id');
     type = type.split("_")[1];
     title = $('.title').val();
     if(title)
     {
  	   url = '/workouts/get_workout_sub_block';
	     $.get(url, {type:type,title:title}, function (data) {
	   });
     }
    else
    {
      $('.title').css('border-color','red');
    }
  });

  $('#publish').click(function(){
    var varify = false;
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
    alert(varify);

    if(!varify){
      $('#new_workout_form').submit();
    }
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

function drag_drop(e, id, obj) {
    var element = e.dataTransfer.getData("Text");
    var text = document.getElementById(element).innerHTML;
    var size = parseInt($('.b'+id).text());

    var block_type = $('#block_type_'+id).val();
    var li_size = $("#block_"+id).find('.met_tab_desc ul li').size();
    var lib_id = element.split("_");
    var check = check_library_count(li_size, block_type, false);
   
    if(check != ''){
      alert(check);
    }
    else if (check_library_present(lib_id[1], obj)){
          alert("Library Already Exists");
      }
      else{
          $("#block_"+id).find('.met_tab_desc ul').append('<li><span class="nummeric">1</span><h6>'+text+'</h6><p>30 seconds</p></li>');
          $('.b'+id).text(size + 1);
          $('#new_workout_form .hidden_field_workout').append('<input type=hidden class="hidden_workout" name=workout['+id+']['+lib_id[1]+'] value='+lib_id[1]+'>');
      }
}


function check_library_count(li_size, block_type, publish){
  var alrt = "";
  if((block_type == "superset")&&(li_size == 2))
    {
      alrt = "Superset Block must have exactly 2 libraries.";
    }
    else if((block_type == "individual")&&(li_size>0))
    {
       alrt = "Individual Block must have exactly 1 library";
    }
    return alrt;
}

function check_library_publish(li_size, block_type){
  var alrt = "";
  if((block_type == "superset")&&(li_size<2))
    {
      alrt = "Superset Block must have exactly 2 libraries.";
    }
    else if((block_type == "individual")&&(li_size<1))
    {
       alrt = "Individual Block must have exactly 1 library";
    }
    else if(block_type == "circuit" && li_size<3)
    {
       alrt = "Circuit Block must have minimum 3 library";
    }
    return alrt;
}

function check_library_present(lib_id, obj){
  var present = false;
  obj.find(".met_tab_desc ul li").each(function(){
    lid = $(this).attr('id').split("_")[1];
    if(lid == lib_id){
      present = true;
      return false
    }
  });
  return present;
}