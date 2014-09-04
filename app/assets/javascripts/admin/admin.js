
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
    alert("ssssssss");
    $('.admin_umcut_mail').val($(this).attr('data_attr'));
    $.fancybox.open({
      href: '#admin_mail_popup',
      openMethod: 'fadescaleIn',
      closeMethod: 'fadescaleOut',
      autoSize: false,
      autoHeight: false,
      height: 338,
      minHeight: 338,
      width: 560,
      padding: [28, 40, 40, 40]
    });
  });

  $(document).on("click",".send_mail",function(){
    $.fancybox.close();
  });
})
