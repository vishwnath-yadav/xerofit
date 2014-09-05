
$(document).ready(function(){
  $(document).on('change','#sorted',function(){
    $('#sorted_by').val($(this).val());
    $('#admin_filter_form').submit();
  });
  $(document).on('change','.mark_btn',function(){
    var mark_as = $(this).find('input').is(':checked');
    var id = $(this).attr('data-id');
     url = '/admin/moves/mark_complete';
	  $.get(url, {mark_as:mark_as, id: id}, function (data) {
	  });
  });
  $(document).on('change','#admin_change_status',function(){
    var value = $(this).val();
    var data = $(this).attr('data_attr').split("_");
    url = '/admin/moves/status_approve';
    $.get(url, {status: value, type: data[0], id: data[1]}, function (data) {
    });
  });

  $(document).on('click','.mail_popup', function(){
    $('.admin_umcut_mail').val($(this).attr('data_attr'));
  });

   $(document).on('click','.send_approve_mail', function(){
    var data = $(this).attr('data_attr').split("_");
    $('.admin_umcut_mail').val(data[0]);
    $('.admin_move_type').val(data[1]);
  });

  $(document).on("click",".send_mail",function(){
    $('#admin_mail_popup').modal('hide');
    $('#uncut_popup').submit();
  }); 
   $(document).on("click",".approve_mail",function(){
    $('#approve_mail_popup').modal('hide');
    $('#approve_popup').submit();
  });

 
  $(document).on('click','.download_video',function(){
    var data_url = $(this).attr('data-url');
    url = '/admin/moves/download_video';
    $.get(url, {url: data_url}, function (data) {
    });
  });
})
