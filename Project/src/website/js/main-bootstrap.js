$(document).ready(function () {

  /* Every time the window is scrolled ... */
  $(window).scroll(function () {
    if ($(".splash").is(":visible")) {
      $(window).off("scroll");
      $(".splash").slideUp(1000, function () {
        $(".wrapper").css({ "display": "block" })
        $(".wrapper").css("opacity", "1");
        $('.wrapper').addClass("animated fadeInUp");
        $("html, body").animate({ "scrollTop": "0px" }, 100);
      });
    }

    /* Check the location of each desired element */
    $('.fade-in-object').each(function (i) {

      console.log("sadasdadas");

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


  document.querySelector(".splash-arrow").addEventListener("webkitAnimationEnd", function (e) {
    $("#splash-arrow-stack").addClass('animated infinite rubberBand');
    $(".splash-arrow").css({ 'opacity': '1' });

  }, false);
});




