({
    doInit : function(c, e, h) {
        h.doInit_Helper(c, e, h);
        window.setTimeout(function () {
            $('.owl-carousel').owlCarousel({
                loop:true, // For Continues after finish.
                margin:10, // Spacing between slides.
                nav:true, // Next or Prev Buttons
                responsive:{
                    0:{
                        items:1 // Divs on the screen on different screen sizes.
                    },
                    600:{
                        items:3
                    },
                    1000:{
                        items:5
                    }
                }
            })
        },5000);
    },
})