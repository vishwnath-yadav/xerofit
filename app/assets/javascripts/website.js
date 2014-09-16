//= require jquery
//= require plugins/bootstrap.min.js
//= require plugins/parsley.min.js
//= require plugins/matchHeight.min.js
//= require plugins/offcanvas-bootstrap.min.js


$(function(){
   $('.hero-bg-flex').css({'height': (($(window).height()))+'px'});
    $('.hero-content-container').css({'height': (($(window).height() - 60))+'px'});
    $(window).resize(function(){
        $('.hero-bg-flex').css({'height': (($(window).height()))+'px'});
        $('.hero-content-container').css({'height': (($(window).height() - 60))+'px'});
    });
});

$(function(){
    $('.discover-link').click(function(event) {
        event.preventDefault();
        alert('Coming Soon!');
    });

    $('.how-it-works-link').click(function(event) {
        event.preventDefault();
        alert('Coming Soon!');
    });

});

$(function() {
    $('.match-col-height').matchHeight();
    $('.section-rs-img').matchHeight('remove');
});