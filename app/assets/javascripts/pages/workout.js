$(document).ready(function() {

  $(document).click(function(event) {
    var target = $(event.target);
    if(!target.is(".load_lib_detail, .load_lib_detail *, #move-details-panel, #move-details-panel *")){
       $('.active_li').removeClass('active_li');
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

  $(document).on('click','body',function(e){
    $('[data-toggle="popover"]').each(function () {
        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
            $(this).popover('hide');
        }
    });
  })

  $(document).on('click','.remove_block',function(){
    var arr = []
    var $input = $(this).closest('li.block-container');
    var id = $input.attr('id').split("_")[1];
    $input.find('li.load_lib_detail').each(function(){
       var lib_detail_id = $(this).attr('id').split("_")[3];
        arr.push(lib_detail_id);
    })
    url = '/builder/remove_block';
    $.get(url, {block_id:id, lib_detail_arr:arr}, function (data) {
      if(data){
        $input.remove();
      }
    });
  })

  
  $(document).on('click','.remove-break-block',function(){
    var $input = $(this).closest('li.break-block');
    var id = $input.attr('id').split("_")[1];
    url = '/builder/remove_block';
    $.get(url, {block_id:id}, function (data) {
      if(data){
        $input.remove();
      }
    });
  })

  // Activate Superset & Circuit Block Popover
  $(document).on('click','.block-settings',function(){
    block_popover_intilization();
    var $input = $(this).closest('li.block-container');
    var sets = $input.find('.content .sets_count').val();
    var rest = $input.find('.content .rest_time').val();
    $input.find('.popover-content .sets_by_popup').each(function(){
      if($(this).attr('name') == "sets_count"){
        $(this).val(sets);
      }else{
        $(this).val(rest);
      }
    })
  });

  // Activate Break Block Popover
  $(document).on('click','.break-block-settings',function(){
    block_popover_intilization();
    var $input = $(this).closest('li.break-block');
    var min = $input.find('.content .minutes').val();
    var sec = $input.find('.content .seconds').val();
    $input.find('.popover-content .water_popup').each(function(){
      if($(this).attr('name') == "minutes"){
        $(this).val(min);
      }else{
        $(this).val(sec);
      }
    })
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

  $(document).on("blur", '.sets_by_popup', function(){
    var libdetails_arr=[];
    var val = parseInt($(this).val());
    var name = $(this).attr('name');
    var $data = $(this).closest('li.block-container');
    $(this).closest('li.block-container').find('.'+name).val(val);
    var block_id = $data.attr('id').split("_")[1];
    $data.find('ul li.others').each(function(){
      if ($(this).attr('id').split('_')[1] == block_id)
      {
      var lib_detail_id = $(this).attr('id').split('_')[3];
        libdetails_arr.push(lib_detail_id);
      }
    })
    url = '/builder/update_move_details';
    $.get(url, {block_id:block_id, value:val, name:name, lib_detail_arr:libdetails_arr}, function (data) {
    });
  });

  $(document).on('blur', ".water_popup", function(){
    var name = $(this).attr('name');
    var value = parseInt($(this).val());
    var $data = $(this).closest('li.break-block');
    $(this).closest('li.break-block').find('.'+name).val(value);
    var block_id = $data.attr('id').split("_")[1];

    url = '/builder/update_break_block_details';
    $.get(url, {block_id:block_id, minute:value, name:name}, function (data) {
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
    else if($('.workout-list').find('li.load_lib_detail').length <= 1){
      verify = false;
      alert("Please create sub blocks with move.");
    }
    else{
      $('.workout-list .cir_super_blk').each(function(){
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
    $('.active_li').removeClass('active_li');
    $("#move-details-panel").css('display', 'none');
  });

  $(document).on("click", ".load_lib_detail", function(e){
    if($(this).hasClass('active_li')){
      alert("d")
      $('.active_li').removeClass('active_li');
      $("#move-details-panel").css('display', 'none');
    }
    else if($(e.target).hasClass('remove_single_move')){
      alert("2")
      var arr = [];
      var $input = $(this).closest('li.block-container');
      var id = $input.attr('id').split("_")[1];
      var lib_detail_id = $input.attr('id').split("_")[3];
      arr.push(lib_detail_id);
      url = '/builder/remove_block';
      $.get(url, {block_id:id, lib_detail_arr:arr}, function (data) {
        if(data){
          $input.remove();
        }
      });
    }
    else{
      alert("3")
      $('.active_li').removeClass('active_li');
      $(this).addClass('active_li');
      var block_id = $(this).attr('id') ? $(this).attr('id') : []
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
    console.log(txt);
    console.log(name);
    console.log(name.indexOf('name'));
    // if(txt == '' && name.indexOf('name') > -1){
    //   alert("Title Can't be blank");    
    // }
    // else if(name.indexOf('subtitle') > -1 && $('.wrk_head').text() == "Workout Title"){
    //   alert("Title Can't be blank");    
    //   $('.wrk_subhead').show();
    //   $(this).parent().remove();
    // }
    // else{
    //   $("#workout_form_auto").submit();
    // }

    if(txt == ''){
      alert("Title Can't be blank");

    }else{
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

  $("#workout-blocks ul li").draggable({
        connectToSortable:'.main_drop_block',
        cursor: 'grabbing',
        zIndex: 9999,
        appendTo: 'body',
        containment: '#workout-builder-app .split-right',
        helper: function() {
            return $("<div class='dragging-block-wrap'></div>").append($(this).clone());
        }
    });

    $("#move ul li").draggable({
        connectToSortable:'.main_drop_block',
        cursor: 'grabbing',
        zIndex: 9999,
        scroll : false,
        appendTo: 'body',
        containment: '#workout-builder-app',
        helper: function() {
          return $("<div class='dragging-move-wrap'></div>").append($(this).clone());
        }
    });

    initialize_drag_drop_js();
});

// $(document).on('page:load', ready);
function initialize_drag_drop_js(){
    var drag_type = '', string = '', block_name = '', lib_id = '',text = '',object = '',flag = true;
    $(".main_drop_block").sortable({
        placeholder: 'sortable-placeholder',
        cursor: 'grabbing',
        receive: function(event, ui) {
            lib_id = ui.item.attr('data-move-id');
            drag_type = ui.item.attr('data-dragable-type');
            var html = [];
            if(drag_type == "block"){
              if($(this).attr('data-block') == "main"){
                  block_name = ui.item.attr("data-block-name");
                  if(block_name == BLOCK_TYPE[2]){
                    object = $(this).find('li.moving');
                    if(object.hasClass('moving') && (typeof object.prev("li").attr('data-blck') != "undefined") && (typeof object.next('li').attr('data-blck') != "undefined")){          
                      html.push($('.water_break_block').html());
                    }else{
                      object.remove();
                      alert("The Break workout block cannot be placed at the beginning or end of a workout.");
                      return false;
                    }
                  }else{
                      if(block_name == BLOCK_TYPE[0]){
                          string = $('.circuit_block').html();
                          html.push(string);
                      }else if(block_name == BLOCK_TYPE[1]){
                          string = $('.superset_block').html();
                          html.push(string);
                      }
                  }
              }
            }else{
              text = ui.item.find('h6').text();
              if($(this).attr('data-block') == "block"){
                  block_name = $(this).attr('data-block-name');
                  var li_size = $(this).find('li.others').size();
                  var alrt = check_library_count(li_size, block_name);
                  if(alrt != ''){
                      alert(alrt);
                      flag = false;
                  }
                  else if(check_library_present(lib_id, $(this))){
                      alert("Library Already Exists");
                      flag = false;
                  }
                  else{
                    var li_length = $(this).find('li.first').size();
                    $(this).find('li.first').remove();
                    
                    string = $('.block_inner_move').html();
                    html.push(string);
                    for (var i = 1; i < li_length; i++) {
                      html.push('<li class="first">'+i+'</li>');
                    }
                  }
                }
                else{
                  block_name = BLOCK_TYPE[3]
                  string = $('.individual_block').html();
                  html.push(string);
                }  
            }
            if($(this).find('li.moving').length){
                $(this).find('li.moving').replaceWith(html.join(''));
            }
            else{
                $(this).find('li').replaceWith(html.join(''));
            }
            $('.for_id b.txt').text(text);
            if(flag){
              save_details(lib_id, block_name, drag_type, $('.workout-list .for_id'));
            }
            $(this).find('li.moving').removeClass('moving');
            initialize_drag_drop_js();
        }, 
        update: function (event, ui){
          if(object != ''){
            object.remove();
          }
          if(ui.item.hasClass('break-block')){
            if((typeof ui.item.prev("li").attr('data-blck') == "undefined") || (typeof ui.item.next('li').attr('data-blck') == "undefined")){
              return false;
            }
          }
          $('.blank-workout-placeholder').remove();
          block_sortable();
        }
    }).disableSelection();
}

function save_details(lib_id, block_name, drag_type, $this){
    var sets = $this.closest('li.block-container').find('.sets_count').val();
    var rests = $this.closest('li.block-container').find('.rest_time').val();
    url = '/builder/create_workout_block';
    $.get(url, {lib_id: lib_id, block_name: block_name, drag_type: drag_type, sets: sets, rest:rests}, function (data) {
        if(drag_type == "block"){
            $this.attr('id', "block_"+data.id);
            $this.find('.content').addClass("setting_"+data.id);
            if(block_name == BLOCK_TYPE[2]){
                $this.attr('id', "block_"+data.id).append('<input type="hidden" name=block['+data.id+'][0] id="block_'+data.id+'_0" value=0>');
            }
          }
          else if(block_name == BLOCK_TYPE[3]){
            $this.attr('id', "block_"+data.id+"_"+lib_id+"_"+data.lib_detail_id).append('<input type="hidden" name=block['+data.id+']['+lib_id+'] id="block_'+data.id+'_'+lib_id+'" value='+data.lib_detail_id+'>');
          }
          else{
            var block_id = $this.closest('li.block-container').attr('id').split("_")[1];
            $this.attr('id', "block_"+block_id+"_"+lib_id+"_"+data.lib_detail_id).append('<input type="hidden" name=block['+block_id+']['+lib_id+'] id="block_'+block_id+'_'+lib_id+'" value='+data.lib_detail_id+'>');
          }
          $this.removeClass('for_id');
    });
}


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
      alrt = BLOCK_TYPE[1]+"The Superset block requires a total of 2 moves";
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

function block_sortable(){
  var i=1;
  $('#workout-editor ul li').each(function(){
    if($(this).hasClass('first') || $(this).hasClass('others') || $(this).hasClass('single_move')){
      $(this).find('.sort_index').each(function(){
        $(this).text(i);
        i=i+1;
      })
    }
  });
}
