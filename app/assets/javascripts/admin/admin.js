$(document).ready(function(){
  $(document).on('change','#sorted',function(){
    $('#sorted_by').val($(this).val());
    $('#admin_filter_form').submit();
  });
})
