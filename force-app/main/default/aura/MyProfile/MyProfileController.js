({
    init : function (c, e, h) {
        h.init_helper(c, e, h);
    },
    upHoverFunction : function (c, e, h) {
        var getSection = e.target.title;
        if(!$A.util.isEmpty(getSection) && getSection != undefined) {
            h.upHoverFunction_helper(c, e, h, getSection);
        }
    },
    downHoverFunction : function (c, e, h) {
        var getSection = e.target.title;
        if(!$A.util.isEmpty(getSection) && getSection != undefined) {
            h.downHoverFunction_helper(c, e, h, getSection);
        }
    },
})