$(document).ready(function() {


  // Sticky header title
  $(window).scroll(function(){
    scroll = $(window).scrollTop();
    var sticky = $('#discover-video-header');
    var stickyContainer = $('#discover-video-header .show-on-scroll');

    if(scroll >= 84){
      sticky.addClass('fixed');
      $('#discover-video-header .show-on-scroll').css('display','block');
      $('.discover .control_bar .control_bar_context').remove('.header-title-wrap');
      $('.discover .control_bar .header-title-wrap').appendTo('#discover-video-header .show-on-scroll');
    }
    else{
      sticky.removeClass('fixed');
      $('#discover-video-header .show-on-scroll').css('display','none');
      $('.header-title-wrap').appendTo('.discover .control_bar .control_bar_context');
      $('#discover-video-header .show-on-scroll').remove('.header-title-wrap');
    }
  });
});