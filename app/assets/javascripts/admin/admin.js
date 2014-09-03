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
})
