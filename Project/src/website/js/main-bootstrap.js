$(document).ready(function () {

  /* Every time the window is scrolled ... */
  $(window).scroll(function () {
    if ($(".splash").is(":visible")) {
      $(window).off("slide");
      $(".splash").slideUp(1000, function () {
        $(".wrapper").css({ "display": "block" })
        $(".wrapper").css("opacity", "1");
        $('.wrapper').addClass("animated fadeInUp");
        $(".splash").css({ "display": "hidden" })
        $('#chapter1').addClass("animated fadeInLeft");
        window.scrollTo(0, 0);
      });
    }
    /* Check the location of each desired element */
    else {
      $(window).on("scroll", function () {
        $('.fade-in-object').each(function (i) {
          var bottom_of_object = $(this).offset().top + $(this).outerHeight();
          var bottom_of_window = $(window).scrollTop() + $(window).height();

          /* Adjust the "300" to either have a delay or that the content starts fading a bit before you reach it  */
          bottom_of_window = bottom_of_window + 300;

          /* If the object is completely visible in the window, fade it it */
          if (bottom_of_window > bottom_of_object) {
            if ($(this).hasClass("fade-on")) {
              $(this).animate({ 'opacity': '1' }, 2000);
            }
            else if ($(this).hasClass("fade-left")) {
              $(this).addClass('animated fadeInLeft');
            }
            else if ($(this).hasClass("fade-right")) {
              $(this).addClass('animated fadeInRight');
            }
          }
        });
      })
    }

  });


  // SPLASH SCREEN
  if ($(".splash").is(":visible")) {
    $(".wrapper").css({ "opacity": "0" });
  }

  $(".splash-arrow").click(function () {
    $(".wrapper").css({ "display": "block" })
    $(".splash").slideUp(1000, function () {
      $(".wrapper").css("opacity", "1");
      $('.wrapper').addClass("animated fadeInUp");
    });
  });

  $(".splash-arrow").on("webkitAnimationEnd", function (e) {
    $("#splash-arrow-stack").addClass('animated infinite rubberBand');
    $(".splash-arrow").css({ 'opacity': '1' });
  });


  $('.interactive-canvas').bind('mouseenter', function (e) {
    disableScroll();
  });

  $('.interactive-canvas').bind('mouseleave', function (e) {
    enableScroll();
  });
});


// Disable scrolling when the mouse pointer is in the interactive canvas.
// Taken from: http://stackoverflow.com/questions/4770025/how-to-disable-scrolling-temporarily

// left: 37, up: 38, right: 39, down: 40,
// spacebar: 32, pageup: 33, pagedown: 34, end: 35, home: 36
var keys = { 37: 1, 38: 1, 39: 1, 40: 1 };

function preventDefault(e) {
  e = e || window.event;
  if (e.preventDefault)
    e.preventDefault();
  e.returnValue = false;
}

function preventDefaultForScrollKeys(e) {
  if (keys[e.keyCode]) {
    preventDefault(e);
    return false;
  }
}

function disableScroll() {
  window.onwheel = preventDefault;
  document.onkeydown = preventDefaultForScrollKeys;
}

function enableScroll() {
  window.onwheel = null;
  document.onkeydown = null;
}






