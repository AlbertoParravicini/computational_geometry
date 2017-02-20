// Set the wrapper (i.e. the content of the page) to visibility = 0,
// if the splash-screen is visible.
$(document).ready(function () {
    if ($(".splash").is(":visible")) {
        $(".wrapper").css({ "opacity": "0" });
    }

    $(".splash-arrow").click(function () {
        $(".wrapper").css({"display": "block"})
        $(".splash").slideUp("800", function () {
            $(".wrapper").delay(100).animate({ "opacity": "1.0" }, 800);
        });
    });

    document.querySelector(".splash-arrow").addEventListener("webkitAnimationEnd",function(e){
        $(".splash-arrow").css({'opacity': '1'});
        $(".splash-arrow").addClass('animated rubberband infinite');
    },false);
});



$(window).scroll(function () {
    $(window).off("scroll");
    $(".splash").slideUp("800", function () {
        $(".wrapper").css({"display": "block"})
        $("html, body").animate({ "scrollTop": "0px" }, 100);
        $(".wrapper").delay(100).animate({ "opacity": "1.0" }, 800);
    });
});

// Source: http://stackoverflow.com/questions/7571370/jquery-disable-scroll-when-mouse-over-an-absolute-div
// Disable page scroll when the mouse cursor is hovering a p5.js canvas.
$('.interactive-canvas').bind('mousewheel DOMMouseScroll', function(e) {
    var scrollTo = null;

    if (e.type == 'mousewheel') {
        scrollTo = (e.originalEvent.wheelDelta * -1);
    }
    else if (e.type == 'DOMMouseScroll') {
        scrollTo = 40 * e.originalEvent.detail;
    }

    if (scrollTo) {
        e.preventDefault();
        $(this).scrollTop(scrollTo + $(this).scrollTop());
    }
});

