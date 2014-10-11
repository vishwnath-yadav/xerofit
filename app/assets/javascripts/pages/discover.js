$(document).ready(function() {


  // Carousel for marketplace lists



  // Sticky header title on move video page
  $(window).scroll(function(){
    scroll = $(window).scrollTop();
    var sticky = $('#discover-video-header');
    var stickyContainer = $('#discover-video-header .show-on-scroll');

    if(scroll >= 84){
      sticky.addClass('fixed');
      sticky.css('border-bottom','1px solid #E3E3E3');
      $('#discover-video-header .show-on-scroll').css('display','block');
      $('.discover .control_bar .control_bar_context').remove('.header-title-wrap');
      $('.discover .control_bar .header-title-wrap').appendTo('#discover-video-header .show-on-scroll');
    }
    else{
      sticky.removeClass('fixed');
      sticky.css('border-bottom','none');
      $('#discover-video-header .show-on-scroll').css('display','none');
      $('.header-title-wrap').appendTo('.discover .control_bar .control_bar_context');
      $('#discover-video-header .show-on-scroll').remove('.header-title-wrap');
    }
  });
});

function loadMarketplaceCarousel (listName) {

  $(listName).owlCarousel({
    responsive: {
        0: {
            items: 4
        }
    },
    //items: 4,
    nav: true,
    slideBy: 4,
    loop: true,
    autoWidth: true,
    margin: 20,
    navRewind: false,
    dots: true,
    //dotsEach: 4,
    // dotData: true,
    //navText: false,


    //slideSpeed : 600,
    //paginationSpeed: 800,
    //dotsSpeed: 600,


    // This option is broken right now
    //navBy: 'page',
    //slideBy: 'page',
  })
}