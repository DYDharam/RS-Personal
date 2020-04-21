({
   doInit : function(c, e, h) {
      h.doInit_helper(c, e, h);
   },
   nextMonth : function(c, e, h) {
       var currentMonthNumber = parseInt(c.get('v.currentMonthNumber')) + 1;
       var currentYear = parseInt(c.get('v.currentYear'));
       if(parseInt(currentMonthNumber) > 12) {
           currentMonthNumber = currentMonthNumber % 12;
           currentYear = currentYear + 1;
       }
       var currentMonthNameFromNumber = h.getMonthNameToDisplay(c, e, h, currentMonthNumber);
       c.set('v.currentMonth', currentMonthNameFromNumber);
       c.set('v.currentYear', currentYear);
       c.set('v.currentMonthNumber', currentMonthNumber);
       var getDay = c.get('v.currentDate');
       var getMonth = c.get('v.currentMonthNumber');
       var getYear = c.get('v.currentYear');
       h.showMonthDetails_helper(c, e, h, getDay, getMonth, getYear);
   },

   previousMonth : function(c, e, h) {
       var currentMonthNumber = parseInt(c.get('v.currentMonthNumber')) - 1;
       var currentYear = parseInt(c.get('v.currentYear'));
       if(parseInt(currentMonthNumber) == 0) {
           currentMonthNumber = 12;
           currentYear = currentYear - 1;
       }
       c.set('v.currentMonthNumber', currentMonthNumber);
       var currentMonthNameFromNumber = h.getMonthNameToDisplay(c, e, h, currentMonthNumber);
       c.set('v.currentMonth', currentMonthNameFromNumber);
       c.set('v.currentYear', currentYear);
       var getDay = c.get('v.currentDate');
       var getMonth = c.get('v.currentMonthNumber');
       var getYear = c.get('v.currentYear');
       h.showMonthDetails_helper(c, e, h, getDay, getMonth, getYear);
   },

})