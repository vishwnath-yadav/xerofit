$(document).ready(function(){

  // $(document).on("click", ".replace_video_btn", function() {
  //    $('.upload_edit').css('display','none');
  //    $('.replace_video').css('display','block');
  //    $('.lib_edit_botom').css('display','none');
  // });
  $(document).on('keyup blur',"input[type=text], textarea", function(){
    var obj = $(this).closest('.input_field_wrap').find('span.detail_char');
    var max_size = parseInt(obj.attr('data-size'));
    var size = $(this).val().length;
    var actual = max_size - size
    obj.text(actual);
  });

  $(document).on("change keyup",".for_on_change",function(){
    $('.chg_save').removeClass('dis_link');
    check_require_field();
  });

  $(document).on("change keyup click dblclick",".for_on_changed",function(){
    $('.chg_save').removeClass('dis_link');
  });

  $(document).on("click",".for_on_change1",function(){
    $('.chg_save').removeClass('dis_link');
    check_require_field();
  });

  $(document).on("click",".del",function(){
    $(this).find(".fancy_select").slideToggle();
  });

  $(document).on("click",".sub_arw ul li",function(){
    var sub_menu=$(this).attr('data-subgroup');
    var sub_cat=$(this).attr('data-subcat');
    var $parent = $(this).closest('ul');
    var menu = $parent.attr('data-group');
    var id = $parent.attr('data-id');
    $('.target_muscle_menu_'+id).val(menu);
    $('.target_muscle_submenu_'+id).val(sub_cat);
    $('.target_'+id).text(sub_menu).css('border', '1px solid #e1e0dd');
    $(".error_msg_"+id).removeClass('lib_error').text("");
  });


  $(document).on('click','.type_select ul li', function(){
    $('#select_option').val("type");
    $('#select_option_val').val($(this).text());
    $('#search_grid_list_form').submit();
  });

  // Switch between Grid View and List View on Library Home
  $(document).on("click", ".view_type", function(){
     var name = $(this).attr('data-name');
     if(name == "grid"){
      $('#grid_view').attr('class','grid_icon grid_icon_active grid_pointer view_type');
      $('#list_view').attr('class','list_icon grid_pointer view_type')
     }
     else{
      $('#grid_view').attr('class','grid_icon grid_pointer view_type');
      $('#list_view').attr('class','list_icon list_icon_active grid_pointer view_type');
     }
     $('#view_type').val(name);
     $('#search_grid_list_form').submit();
  });

  // Search functionality on Library Index
  $(document).on("click","#lib_name_for_search",function(){
  	$('#search_grid_list_form').submit();
  });

  $(document).on("click",".search_bar_clear",function(){
    $("#search_lib_by_name").val('');
    $(".search_bar_clear").addClass('hide');
    $('#search_grid_list_form').submit();
  });

  $(document).on("keyup, mouseup", '#search_lib_by_name', function(e){
      $(".search_bar_clear").removeClass('hide');
      if(e.which == 13){//Enter key pressed
        $('#search_grid_list_form').submit();
      }
  });

  // var companyList = $("input[data-autocomplete]").autocomplete({ 
  //     change: function() {
  //         alert('changed');
  //         $('#search_grid_list_form').submit();
  //     }
  //  });
  //  companyList.autocomplete('option','change').call(companyList);

  // $('input[data-autocomplete]').bind('railsAutocomplete.select', function(event, ui) {
  //     alert("Dfdsdfs");
  //     $('#search_grid_list_form').submit();
  // });
  $('#search_lib_by_name').bind('railsAutocomplete.select', function(event, data){
    /* Do something here */
    $('#search_grid_list_form').submit();
  });


  // Sorting functionality in Library List View
  $(document).on("click",".column_sort",function(){
    $("#sorted_by").val($(this).attr('data-sort'));
    $("#order").val($(this).attr('data-order'));
    $('#search_grid_list_form').submit();
  });

});

function check_require_field(){
  var flag= 1;
  $(".for_on_change").each(function() {
    key = $(this).val();
    if(key == null || key == '')
    {
      flag=0;
    }
  });

  var target = $('.for_target_change').val();
  var len = $(".select_thumb").length;

  if((len <= 0)||(target == null)||(target == '')){
    flag = 0;
  }
  if(flag == 1){
    $('.chg_lin').removeClass('dis_link');
  }
  else{
    $('.chg_lin').attr('class','cancel_btn rht_active edit_lib dis_link chg_lin');
  }
}

function show_text_actual_size(){
  $('.detail_char').each(function(){
    var size = $(this).attr('data-size');

    var input_len = $(this).closest('.input_field_wrap').find('input, textarea').val().length;
     var actual = size - input_len;
      $(this).text(actual);
  })
}

$(document).mouseup(function (e)
{
    var container = $(".fancy_select.target_muscle_select");

    if (!container.is(e.target) // if the target of the click isn't the container...
        && container.has(e.target).length === 0) // ... nor a descendant of the container
    {
        container.hide();
    }
});
