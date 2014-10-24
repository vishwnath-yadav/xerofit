$(document).ready(function() {

  popover_hide();

  $(document).click(function(event) {
    var target = $(event.target);
    if($('.workout-title-input').is(':visible')){
      manage_wrk_title(target);
      return false;
    }
    if(!target.is(".load_lib_detail, .load_lib_detail *, #move-details-panel, #move-details-panel *")){
       $('.active_li').removeClass('active_li');
       $("#move-details-panel").css('display', 'none');
    }
  });

  $(document).on('change', ".lib_detail_sel", function(){
    $(".edit_move_detail").submit();
  });

  // Sticky header title
  $(window).scroll(function(){
    scroll = $(window).scrollTop();

    if(scroll >= 84){
      $('.show-on-scroll').css('display','block');
      $('.workout-builder .control_bar .control_bar_context').remove('.library-thumbnail-container, .workout-title-wrap');
      $('.workout-builder .control_bar .library-thumbnail-container').appendTo('.header-scroll.workout-builder .show-on-scroll');
      $('.workout-builder .control_bar .workout-title-wrap').appendTo('.header-scroll.workout-builder .show-on-scroll');
      $('.workout-title-wrap').addClass('scrolling');
    }
    else{
      $('.show-on-scroll').css('display','none');
      $('.library-thumbnail-container').appendTo('.workout-builder .control_bar .control_bar_context');
      $('.workout-title-wrap').appendTo('.workout-builder .control_bar .control_bar_context');
      $('.header-scroll.workout-builder .show-on-scroll').remove('.library-thumbnail-container, .workout-title-wrap');
      $('.workout-title-wrap').removeClass('scrolling');
    }
  });


  // Tooltips for workout editor buttons
  $('.builder-tooltip').tooltip({
    placement: 'bottom',
    container: 'body'
  });


  // Delete circuit and superset block from popover
  $(document).on('click','.remove_block',function(){
    var arr = []
    var count = 0;
    var $input = $(this).closest('li.block-container');
    var id = $input.attr('id').split("_")[1];
    $input.find('li.load_lib_detail').each(function(){
       var lib_detail_id = $(this).attr('id').split("_")[3];
        arr.push(lib_detail_id);
        count = count + 1;
    })
    subtract_move_count(count);
    url = '/builder/remove_block';
    $.get(url, {block_id:id, lib_detail_arr:arr}, function (data) {
      if(data){
        $input.remove();
        block_sortable();
      }
    });
  })

  // Delete break block from popover button
  $(document).on('click','.remove-break-block',function(){
    var $input = $(this).closest('li.break-block');
    var id = $input.attr('id').split("_")[1];
    url = '/builder/remove_block';
    $.get(url, {block_id:id}, function (data) {
      if(data){
        $input.remove();
        block_sortable();
      }
    });
  })

  // Activate Superset & Circuit Block Popover
  $(document).on('click','.block-settings',function(){
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

    $('.workout-builder .control_bar .control_bar_context').remove('.library-thumbnail-container, .workout-title-wrap');
    $('.workout-builder .control_bar .library-thumbnail-container').appendTo('.header-scroll.workout-builder .show-on-scroll');
    $('.workout-builder .control_bar .workout-title-wrap').appendTo('.header-scroll.workout-builder .show-on-scroll');
    return false;
  });

  $(document).on('click','#exit-fullscreen', function(){
    window.scrollTo(0, 0);
    //$('.show-on-scroll').css('display','none');
    $('body').removeClass('disable-scroll');
    $('#exit-fullscreen').addClass('hide');
    $('#enter-fullscreen').removeClass('hide');

    $('.library-thumbnail-container').appendTo('.workout-builder .control_bar .control_bar_context');
    $('.workout-title-wrap').appendTo('.workout-builder .control_bar .control_bar_context');
    $('.header-scroll.workout-builder .show-on-scroll').remove('.library-thumbnail-container, .workout-title-wrap');

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

  $(document).on("click", '.save_block_popover', function(){
    setting_sets_and_rests($(this));
  });

  $(document).on('click', ".save_break_block_popover", function(){
    var $data = $(this).closest('li.break-block');
    var min = $data.find('.popover-content .water_popup').first().val();
    var sec = $data.find('.popover-content .water_popup').last().val();
    $data.find('.content .minutes').val(min);
    $data.find('.content .seconds').val(sec);
    var block_id = $data.attr('id').split("_")[1];
    $("#block_"+block_id).find('.block-options').text( min + " min " + sec + " sec");
    $('.break-block-settings').click();
    url = '/builder/update_break_block_details';
    $.get(url, {block_id:block_id, minute:min, second:sec}, function (data) {
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
    var check = $('.workout-list').find('li').first().hasClass('break-block');
    var check1 = $('.workout-list').find('li').last().hasClass('break-block');
    if(!$('#workid').length){
      verify = false;
      alert("Please enter a title for the workout before saving.");
    }
    else if($('.workout-list').find('li.load_lib_detail').length <= 1){
      verify = false;
      alert("Please make sure all your blocks have moves before saving.");
    }
    else if(check || check1){
      verify = false;
      alert("Please change the order, break will not first or last in workout order.");
    }
    else{
      $('.workout-list .cir_super_blk').each(function(){
        var block_name = $(this).find('ul').attr('data-block-name');
        var block_li_size = $(this).find('ul li.block-move').size();
        var check = check_library_publish(block_li_size,block_name)
        if(check != ''){
          verify = false;
          alert(check);
          return false;
        }

      });
    }
    if(verify){
      block_indexing();
      $('#new_workout_form').submit();
    }
  });


  $(document).on('click','.close-panel', function(){
    $('.active_li').removeClass('active_li');
    $("#move-details-panel").css('display', 'none');
  });

  $(document).on("click", ".load_lib_detail", function(e){
    if($(this).hasClass('active_li')){
      $('.active_li').removeClass('active_li');
      $("#move-details-panel").css('display', 'none');
    }
    else if($(e.target).hasClass('remove-single-move')){
      remove_moves($(this));
    }
    else{
      activate_moves($(this));
    }
  });

  // Dropdown
  $(document).on('change', ".lib_detail_chk", function(){
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

  $(document).on('click', ".edit-workout-title", function(){
      $('.workout-title').hide();
      $('.workout-title-input').show();
      $('.title-textbox').focus();
      return false;
  });

  // $(document).on('blur', ".title-textbox", function(e){
    
  // });

  // $(document).on('blur', ".save-workout-title", function(){
  //   var txt = $('.title-textbox').val();
  //   if(txt == ''){
  //     alert("Title Can't be blank");
  //   }else{
  //     $("#workout_form_auto").submit();
  //   }
  // });

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

function manage_wrk_title(target){
  if(target.hasClass('save-workout-title')){
    var txt = $('.title-textbox').val();
    if(txt == ''){
      alert("The workout title cannot be blank. Please enter a title for this workout");
    }else{
      $("#workout_form_auto").submit();
    }
    return false;
  }
  else if(!target.is('.title-textbox')){
    $('.workout-title').show();
    $('.workout-title-input').hide();
    return false;
  }
}

function setting_sets_and_rests($this){
  var libdetails_arr=[];
  var $data = $this.closest('li.block-container');
  var block_id = $data.attr('id').split("_")[1];
  var sets = $data.find('.popover-content .sets_by_popup').first().val();
  var rest = $data.find('.popover-content .sets_by_popup').last().val();
  $data.find('.content .sets_count').val(sets);
  $data.find('.content .rest_time').val(rest);
  if($data.attr('data-blck') == "superset"){
     $("#block_"+block_id).find('.block-options').text( sets + " Sets with no rest");
  }else{
     $("#block_"+block_id).find('.block-options').text( sets + " Sets with " + rest + " seconds rest");
  }

  $data.find('ul li.block-move').each(function(){
    if ($(this).attr('id').split('_')[1] == block_id)
    {
    var lib_detail_id = $(this).attr('id').split('_')[3];
      libdetails_arr.push(lib_detail_id);
    }
  })

  // popover_hide()
  $('.block-settings').click();
  url = '/builder/update_move_details';
  $.get(url, {block_id:block_id, sets:sets, rest:rest, lib_detail_arr:libdetails_arr}, function (data) {
  });
}

// $(document).on('page:load', ready);
function initialize_drag_drop_js(){
    var drag_type = '', string = '', block_name = '', lib_id = '',text = '',object = '',flag = true, check=true;
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
                  var li_size = $(this).find('li.block-move').size();
                  var alrt = check_library_count(li_size, block_name);
                  if(alrt != ''){
                      alert(alrt);
                      flag = false;
                  }
                  else if(check_library_present(lib_id, $(this))){
                      alert("This move has already been added to this block");
                      flag = false;
                  }
                  else{
                    var li_length = $(this).find('li.block-move-placeholder').size();
                    $(this).find('li.block-move-placeholder').remove();

                    string = $('.block_inner_move').html();
                    html.push(string);
                    check = add_move_count();
                    if(!check){
                      return false;
                    }
                    for (var i = 1; i < li_length; i++) {
                      html.push('<li class="block-move-placeholder">'+i+'</li>');
                    }
                  }
                }
                else{
                  block_name = BLOCK_TYPE[3]
                  string = $('.individual_block').html();
                  html.push(string);
                  check = add_move_count();
                  if(!check){
                    return false;
                  }
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
          if(!check){
            $('.workout-list').find('li.moving').remove();
            alert("You have reached the max number of moves (99) that can be added to a single workout.");
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

function remove_moves($this){
  var arr = [];
  var $input = $this.closest('li.load_lib_detail');
  var id = $input.attr('id').split("_")[1];
  var lib_detail_id = $input.attr('id').split("_")[3];
  var move_type = $input.hasClass('block-container') ? '' :  "inner";
  subtract_move_count(1);
  arr.push(lib_detail_id);
  url = '/builder/remove_block';
  $.get(url, {block_id:id, lib_detail_arr:arr,move_type: move_type}, function (data) {
    if(data){
      var lis = add_blank_lis($input.closest('li.block-container'));
      $input.after(lis);
      $input.remove();
      block_sortable();
    }
  });
}

function activate_moves($this){
  $('.active_li').removeClass('active_li');
  $this.addClass('active_li');
  var block_id = $this.attr('id') ? $this.attr('id') : []
  if(block_id){
    var lib_detail = block_id.split("_")[3];
    load_library_content(lib_detail, block_id);
  }
}

function add_blank_lis($this){
  var block_name = $this.attr('data-blck');
  var li_length = block_name == BLOCK_TYPE[0] ? 4 : block_name == BLOCK_TYPE[1] ? 3 : 0
  var blank_lis = ''
  var count_lib = $this.find('li.block-move').length ? $this.find('li.block-move').length - 1 : 0;
  $this.find('li.block-move-placeholder').remove();
  for (var i = 1; i < (li_length - count_lib); i++) {
    blank_lis += '<li class="block-move-placeholder">'+i+'</li>';
  }
  return blank_lis;
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

function add_move_count(){
  var count = $('.moves_count').val();
  if(parseInt(count)<99){
    $('.moves_count').val(parseInt(count)+1);
    $('#number_of_moves').val(parseInt(count)+1);
    return true;
  }else{
    return false;
  }
}

function subtract_move_count(no_of_moves){
  var count = $('.moves_count').val();
  if(parseInt(count)>0){
    $('.moves_count').val(parseInt(count)-parseInt(no_of_moves));
    $('#number_of_moves').val(parseInt(count)-parseInt(no_of_moves));
  }
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
  type = $('#'+block_id).attr('data-blck');
  var url = '/builder/load_lib_details';
  $.get(url, {lib_detail_id:lib_detail_id, blk_type: type}, function (data) {
    //$("#move-details-panel").html(data);
   });
}

function check_library_publish(li_size, block_type){
  var alrt = "";
  if((block_type == BLOCK_TYPE[1])&&(li_size<2)){
    alrt = BLOCK_TYPE[1]+" block requires a total of 2 moves.";
  }else if((block_type == BLOCK_TYPE[0])&&(li_size<3)){
    alrt = BLOCK_TYPE[0]+" block requires at least 3 moves.";
  }
  return alrt;
}

function check_library_present(lib_id, $this){
  var present = false;
  $this.find("li.block-move").each(function(){
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
    html: true,
    //container: 'body',
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
    if($(this).hasClass('block-move-placeholder') || $(this).hasClass('block-move') || $(this).hasClass('single_move')){
      $(this).find('.sort_index').each(function(){
        $(this).text(i);
        i=i+1;
      })
    }
  });
}

function block_indexing(){
  var ids = '';
  var length = $('.workout-list .block-container').length;
  for(i=0;i<length;i++){
    if($('.workout-list .block-container:eq('+i+')').length){
      var id = $('.workout-list .block-container:eq('+i+')').attr('id').split('_')[1];
      ids = ids != '' ? ids + ','+id : id;
    }
  }
  $('#indexes').val(ids);
}

function popover_hide(){
  $(document).on('click','body',function(e){
    $('[data-toggle="popover"]').each(function () {
        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
            $(this).popover('hide');
        }
    });
  })
}
