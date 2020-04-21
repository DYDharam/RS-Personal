({
    doInit_helper : function(c, e, h) {
        var currentDate = new Date();
        var getDay = currentDate.getDate();        
        var getMonth = currentDate.getMonth() + 1;
        var getYear = currentDate.getFullYear();
        h.setCalenderDetails_helper(c, e, h, getDay, getMonth, getYear);
    },
    setCalenderDetails_helper : function(c, e, h, getDay, getMonth, getYear) {  
        var newDateWithDayName = new Date(getYear, getMonth - 1, 1);
        var newDateWithDayNameToString = newDateWithDayName.toString();
        var newDateWithDayNameArr = newDateWithDayNameToString.split(' ');
        var newDateWithDayName = newDateWithDayNameArr[0];
        var newDateWithMonthName = newDateWithDayNameArr[1];
        var showMonth = h.getMonthNameToDisplay(c, e, h, newDateWithMonthName);
        var printBlankNumber = h.printBlankNumber(c, e, h, newDateWithDayName);
        var currentDayFinal = 3;
        var totalDaysInMonth = h.getDaysInMonth(c, e, h, getMonth, getYear);
        var calenderRowsObj = [];
        for(var blankFirst = 1; blankFirst <= printBlankNumber; blankFirst++) {
            calenderRowsObj.push('');
        }
        for(var i = 1; i <= totalDaysInMonth; i++) {   
            calenderRowsObj.push(i);
        }
        var totalLastBlankPrint = ((parseInt(printBlankNumber + totalDaysInMonth)) % 7);
        for(var blankLast = 1; blankLast <= 7 - totalLastBlankPrint; blankLast++) {
            calenderRowsObj.push('');
        }
        c.set('v.currentDate', getDay);
        c.set('v.currentMonthNumber', getMonth);
        c.set('v.currentMonth', showMonth);
        c.set('v.currentYear', getYear);
        c.set('v.calenderRows', calenderRowsObj);
    },
    getDaysInMonth : function(c, e, h, month, year) {
        return new Date(year, month, 0).getDate();
    },
    printBlankNumber : function(c, e, h, currentDay) {  
        if(currentDay == 'Monday' || currentDay == 'Mon') {
            return 1;
        }
        if(currentDay == 'Tuesday' || currentDay == 'Tue') {
            return 2;    
        }
        if(currentDay == 'Wednesday' || currentDay == 'Wed') {   
            return 3;
        }
        if(currentDay == 'Thursday' || currentDay == 'Thu') {   
            return 4;
        }
        if(currentDay == 'Friday' || currentDay == 'Fri') {   
            return 5;
        }
        if(currentDay == 'Saturday' || currentDay == 'Sat') {   
            return 6;
        }
        if(currentDay == 'Sunday' || currentDay == 'Sun') {   
            return 7;
        }
    },
    getMonthNameToDisplay : function(c, e, h, sortName) {  
        if(sortName == 'Jan' || parseInt(sortName) == 1) {
            return 'January';
        } else if(sortName == 'Feb' || parseInt(sortName) == 2) {
            return 'Febuary';
        } else if(sortName == 'Mar' || parseInt(sortName) == 3) {
            return 'March';
        } else if(sortName == 'Apr' || parseInt(sortName) == 4) {
            return 'April';
        } else if(sortName == 'May' || parseInt(sortName) == 5) {
            return 'May';
        } else if(sortName == 'Jun' || parseInt(sortName) == 6) {
            return 'June';
        } else if(sortName == 'Jul' || parseInt(sortName) == 7) {
            return 'July';
        } else if(sortName == 'Aug' || parseInt(sortName) == 8) {
            return 'August';
        } else if(sortName == 'Sep' || parseInt(sortName) == 9) {
            return 'September';
        } else if(sortName == 'Oct' || parseInt(sortName) == 10) {
            return 'October';
        } else if(sortName == 'Nov' || parseInt(sortName) == 11) {
            return 'November';
        } else if(sortName == 'Dec' || parseInt(sortName) == 12) {
            return 'December';
        }
    },
    showMonthDetails_helper : function(c, e, h, getDay, getMonth, getYear) {  
        h.setCalenderDetails_helper(c, e, h, getDay, getMonth, getYear);
    },
})