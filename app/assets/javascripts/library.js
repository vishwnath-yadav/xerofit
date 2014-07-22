$( document ).ready(function() {
  $(document).on("change", ".sel_opt", function(){
     var name = $(this).attr('data-name');
     $('#select_option').val(name);
  });

  $(document).on("change", ".view_type", function(){
     var name = $(this).attr('data-name');
     $('#view_type').val(name);
  });
});

