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
})
