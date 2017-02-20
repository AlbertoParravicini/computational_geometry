// Set the wrapper (i.e. the content of the page) to visibility = 0,
// if the splash-screen is visible.
$(document).ready(function () {
    if ($(".splash").is(":visible")) {
        $(".wrapper").css({ "opacity": "0" });
    }

    $(".splash-arrow").click(function () {
        $(".wrapper").css({"display": "block"})
        $(".splash").slideUp(1000, function () {
            $(".wrapper").delay(100).animate({ "opacity": "1.0" }, 1000);
        });
    });

    document.querySelector(".splash-arrow").addEventListener("webkitAnimationEnd",function(e){
        $(".splash-arrow").css({'opacity': '1'});
        $(".splash-arrow").addClass('animated rubberband infinite');
    },false);
});



$(window).scroll(function () {
    $(window).off("scroll");
    $(".splash").slideUp(1000, function () {
        $(".wrapper").css({"display": "block"})
        $("html, body").animate({ "scrollTop": "0px" }, 100);
        $(".wrapper").delay(100).animate({ "opacity": "1.0" }, 1000);
    });
});



// Disable scrolling when the mouse pointer is in the interactive canvas.
// Taken from: http://stackoverflow.com/questions/4770025/how-to-disable-scrolling-temporarily

// left: 37, up: 38, right: 39, down: 40,
// spacebar: 32, pageup: 33, pagedown: 34, end: 35, home: 36
var keys = {37: 1, 38: 1, 39: 1, 40: 1};

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
  document.onkeydown  = preventDefaultForScrollKeys;
}

function enableScroll() {
    window.onwheel = null; 
    document.onkeydown = null;  
}

$('.interactive-canvas').bind('mouseenter', function(e) {
    disableScroll();
});

$('.interactive-canvas').bind('mouseleave', function(e) {
    enableScroll();
});
