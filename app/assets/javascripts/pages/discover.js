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

  //Discover list page searching js

  $(document).on('change','.select_target_muscle_group',function(){
    $('#search_in_discover_data').submit();
  });

  $(document).on('change','.select_category',function(){
    $('#search_in_discover_data').submit();
  });

  $(document).on("focus", '#search_approve_move', function(){
    $(this).css('text-align', 'left');
    $(".search_bar_clear1").removeClass('hide');
    $('.search_bar_icon').addClass('hide');
    $(this).css({
      'padding-left': '12px',
      'color': '#4C4D4E',
    });
  });

  $(document).on("keyup, mouseup", '#search_approve_move', function(e){
      if(e.which == 13){//Enter key pressed
        $('#search_in_discover_data').submit();
      }
  });

  $(document).on("blur", '#search_approve_move', function(){
    var inputText = $.trim($(this).val());
    if(inputText.length>0)
    {
    } else {
      $(this).css('text-align', 'center');
      $(".search_bar_clear1").addClass('hide');
      $('.search_bar_icon').removeClass('hide');
      $(this).css('padding-left', '30px');
    }
    $('#search_in_discover_data').submit();
  });

  $(document).on("click",".search_bar_clear1",function(e){
    $("#search_approve_move").val('');
    $(".search_bar_clear1").addClass('hide');
    $('.search_bar_icon').removeClass('hide');
    $('#search_approve_move').css({
      'padding-left': '30px',
      'text-align': 'center',
      'color': '#CCCCCC'
    });
    $('#search_in_discover_data').submit();
  });

  $('#search_approve_move').bind('railsAutocomplete.select', function(event, data){
    $('#search_in_discover_data').submit();
  });

  //Discover home page searching js

  $(document).on('change','.move_category',function(){
    $('#search_for_discover_home').submit();
  });

  $(document).on("focus", '#discover_home_move_title', function(){
    $(this).css('text-align', 'left');
    $(".search_bar_clear2").removeClass('hide');
    $('.search_bar_icon').addClass('hide');
    $(this).css({
      'padding-left': '12px',
      'color': '#4C4D4E',
    });
  });

  $(document).on("keyup, mouseup", '#discover_home_move_title', function(e){
      if(e.which == 13){//Enter key pressed
        $('#search_for_discover_home').submit();
      }
  });

  $(document).on("blur", '#discover_home_move_title', function(){
    var inputText = $.trim($(this).val());
    if(inputText.length>0)
    {
    } else {
      $(this).css('text-align', 'center');
      $(".search_bar_clear2").addClass('hide');
      $('.search_bar_icon').removeClass('hide');
      $(this).css('padding-left', '30px');
    }
    $('#search_for_discover_home').submit();
  });

  $(document).on("click",".search_bar_clear2",function(e){
    $("#discover_home_move_title").val('');
    $(".search_bar_clear2").addClass('hide');
    $('.search_bar_icon').removeClass('hide');
    $('#discover_home_move_title').css({
      'padding-left': '30px',
      'text-align': 'center',
      'color': '#CCCCCC'
    });
    $('#search_for_discover_home').submit();
  });

  $('#discover_home_move_title').bind('railsAutocomplete.select', function(event, data){
    $('#search_for_discover_home').submit();
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
    navText: true,


    //slideSpeed : 600,
    //paginationSpeed: 800,
    //dotsSpeed: 600,


    // This option is broken right now
    //navBy: 'page',
    //slideBy: 'page',
  })
}

function playPause(){ 
  if (myVideo.paused){
    myVideo.play(); 
  }
  else{
    myVideo.pause(); 
  } 
} 

function initialize_video_events(){
  var flag = 0;
  var myVideo = document.getElementById("move_video");
  var data = $('#move_video').attr('data-attr');
  var data_id = data.split("_")[1];

  window.addEventListener("keypress", function (evt) {
      var SPACEBAR = 32;
      if (evt.which === SPACEBAR) {
          playPause(myVideo);
          evt.preventDefault();
      }
  });

  myVideo.addEventListener("play", function () {
    if(flag == 0){
      url = '/discover/discover_video_info';
      $.get(url, {move_id:data_id}, function (data) {
      });
      flag = 1;   
    }
  }, false);

  myVideo.addEventListener("ended", function () {
    if(flag == 1){
      var video_info_id = $('#move_video_info').val();
      url = '/discover/discover_video_info';
      $.get(url, {move_id:data_id,video_id:video_info_id}, function (data) {
      });
      flag = 0; 
    }
  }, false);
}