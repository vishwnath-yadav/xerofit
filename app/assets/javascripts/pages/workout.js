$(document).ready(function() {

  $(document).click(function(event) {
    var target = $(event.target);
    if(!target.is(".block_li, .block_li *, #move-details-panel, #move-details-panel *")){
       $('.li_active').removeClass('li_active');
       $("#move-details-panel").css('display', 'none');
    }
  });

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

  $(document).on('blur', ".lib_detail_popup", function(){
    var libdetails_arr=[];
    var $input = $(this).find('input');
    var val = parseInt($input.val());
    var name = $input.attr('name');
    var $data = $(this).closest('li.main_container');
    var block_id = $data.attr('id').split("_")[1];
    $data.find('ul li.others').each(function(){
      if ($(this).attr('id').split('_')[1] == block_id)
      {
      var lib_detail_id = $(this).attr('id').split('_')[3];
        libdetails_arr.push(lib_detail_id);
      }
    })
    url = '/builder/update_move_details';
    $.get(url, {block_id:block_id,  value:val, name:name, lib_detail_arr:libdetails_arr}, function (data) {
    });
  });

  $(document).on('blur', ".water_detail", function(){
    var $input = $(this).find('#minutes');
    var $input1 = $(this).find('#seconds');
    var val = parseInt($input.val());
    var val1 = parseInt($input1.val());
    var id = $input.attr('data-block-id');
    
    url = '/builder/update_water_block_details';
    $.get(url, {block_id:id, minute:val, second:val1}, function (data) {
    });
  });

  $('#search-move-by-title').bind('railsAutocomplete.select', function(event, data){
    $('#filter_search_form').submit();
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
    else if($('.add_photo').find('li').length <= 1){
      verify = false;
      alert("Please create sub blocks.");
    }
    else{
      $('.main_ul .cir_super_blk').each(function(){
        var block_name = $(this).find('ul').attr('data-block-name');
        var block_li_size = $(this).find('ul li.others').size();
        var check = check_library_publish(block_li_size,block_name)
        if(check != ''){
          verify = false;
          alert(check);
          return false;
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

  $(document).on("click",".load_lib_detail", function(e){
    if($(e.target).hasClass("rm")){
      var hiden_field_id = $(this).attr('id');
      var main_block_id = hiden_field_id.split('_')[0];
      $("#block_"+hiden_field_id).remove();
      $('#block_'+main_block_id).remove();
      remove_library_from_block(hiden_field_id);
      $(this).remove();
    }
    else{
      var $this = $(this);
      $('.li_active').removeClass('li_active');
      $this.addClass('li_active');
      var block_id = $this.attr('id') ? $this.attr('id') : []
      if(block_id){
        var lib_detail = block_id.split("_")[3];
        load_library_content(lib_detail, block_id);
      }
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


  $(document).on('click', ".met_head", function(e){
    if($(e.target).is('span *')){
            e.preventDefault();
            return;
        }
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

  
});

// $(document).on('page:load', ready);

    
function remove_library_from_block(id){
  url = '/builder/remove_library_from_block';
  $.get(url, {lib_block:id}, function (data) {
  });
}

function remove_msg(){
  $('.success').removeClass('move_detail').html('');
}


function check_library_count(li_size, block_type){
  var alrt = "";
  if((block_type == BLOCK_TYPE[1])&&(li_size == 2)){
      alrt = BLOCK_TYPE[1]+" Block must have exactly 2 libraries.";
  }
  return alrt;
}

function load_library_content(lib_detail_id, block_id){
  setTimeout(function() {
    $("#move-details-panel").show();
    $("#move-details-panel").html('<img src="/assets/ajax-loader.gif" class="m50">');
  })
  sets_val = $('#block_'+block_id).find('#moves_sets').val();
  rests_val = $('#block_'+block_id).find('#moves_rests').val();
  var url = '/builder/load_lib_details';
  $.get(url, {lib_detail_id:lib_detail_id, sets:sets_val, rests:rests_val}, function (data) {
    //$("#move-details-panel").html(data);
   });
}

function check_library_publish(li_size, block_type){
  var alrt = "";
  if((block_type == BLOCK_TYPE[1])&&(li_size<2)){
    alrt = BLOCK_TYPE[1]+" Block must have exactly 2 libraries.";
  }else if((block_type == BLOCK_TYPE[0])&&(li_size<3)){
    alrt = BLOCK_TYPE[0]+" Block must have minimum 3 library";
  }
  return alrt;
}

function check_library_present(lib_id, $this){
  var present = false;
  $this.find("li.others").each(function(){
    if($(this).attr('id')){
      lid = $(this).attr('id').split("_")[2];
      if(lid == lib_id){
        present = true;
        return true;
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

function block_popover_intilization(){
  $("[data-toggle='popover']").popover({
    html:true,
    title: function () {
        return $(this).parent().find('.head').html();
    },
    content: function () {
        return $(this).parent().find('.content').html();
    }
  });
}