$(document).ready(function() {
  full_workout = false;
  $(document).bind('drop dragover', function (e) {
    e.preventDefault();
  });

  $(document).on("click", ".full_workout", function(){
    upload_video_fancybox($(this))
  });
});

function upload_video_fancybox(obj){
  var is_edit_video = obj.attr('data-edit');
  $.fancybox.open({
      href: '#dragandrophandler',
      openMethod: 'fadescaleIn',
      closeMethod: 'fadescaleOut',
      autoSize: false,
      autoHeight: false,
      height: 338,
      minHeight: 338,
      width: 560,
      padding: [28, 40, 40, 40],

      beforeLoad: function () {
        full_workout = true;
        var url = '/library/full_workout_content';
        $.get(url, {video_id:is_edit_video}, function (data) {
        });
      },
      afterClose: function () {
          window.location.reload();
      }
  });
}

function html_setups(response){
  prg.parent().find('p').text('Upload Completed!');
  $(".video_id").val(response);
  $('#panda_video_enable').removeClass('dis_cls').addClass('rht_active');
  $('a.upload_done').removeClass('hide');  
}


