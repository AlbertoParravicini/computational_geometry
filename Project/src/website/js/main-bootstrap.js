$(document).ready(function () {

  /* Every time the window is scrolled ... */
  $(window).scroll(function () {

    /* Check the location of each desired element */
    $('.fade-in-object').each(function (i) {

      var bottom_of_object = $(this).offset().top + $(this).outerHeight();
      var bottom_of_window = $(window).scrollTop() + $(window).height();

      /* Adjust the "200" to either have a delay or that the content starts fading a bit before you reach it  */
      bottom_of_window = bottom_of_window + 100;

      /* If the object is completely visible in the window, fade it it */
      if (bottom_of_window > bottom_of_object) {
        if ($(this).hasClass("fade-in")) {
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

});