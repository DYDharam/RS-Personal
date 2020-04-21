({
	closeMe_helper : function(c, e, h)  {
        c.destroy();
	},
	/* For the Add Question Section Start */
	addMoreRecord_helper : function (c, e, h, onload) {
        if(onload) {
            var newListOfOptions = [];
            var newListOfOptionsObject = {};
            newListOfOptionsObject.isValid = false;
            newListOfOptionsObject.optons = '';
            newListOfOptionsObject.index = parseInt('1');
            newListOfOptionsObject.showAddButton = true;
            newListOfOptions.push(newListOfOptionsObject);
            c.set('v.answerOptionList', newListOfOptions);
        } else {
            var answerOptionList = c.get('v.answerOptionList');
            var getIndex = e.getSource().get('v.name');
            var newListOfOptionsObject = {};
            newListOfOptionsObject.isValid = false;
            newListOfOptionsObject.optons = '';
            newListOfOptionsObject.index = parseInt(answerOptionList.length + 1);
            newListOfOptionsObject.showAddButton = false;
            answerOptionList.push(newListOfOptionsObject);
            c.set('v.answerOptionList', answerOptionList);
        }
    },
    deleteOptionRecord_helper : function (c, e, h) {
        var getIndex = e.getSource().get('v.name');
        var answerOptionList = c.get('v.answerOptionList');
        var optionListAfterDelete = [];
        if(!$A.util.isEmpty(answerOptionList) && answerOptionList != undefined && !$A.util.isEmpty(getIndex) && getIndex != undefined) {
            for(var i = 0; i < answerOptionList.length; i++) {
                if(answerOptionList[i].index != getIndex) {
                    optionListAfterDelete.push(answerOptionList[i]);
                }
            }
            c.set('v.answerOptionList', optionListAfterDelete);
        }
    },
    saveQuestionDetails_helper : function (c, e, h) {
        var answerOptionList = c.get('v.answerOptionList');
        var questionName = c.get('v.questionName');
        var optionAnswerList = [];
        if(!$A.util.isEmpty(answerOptionList) && answerOptionList != undefined) {
            for(var i = 0; i < answerOptionList.length; i++) {
                if(!$A.util.isEmpty(answerOptionList[i].optons) && answerOptionList[i].optons != undefined) {
                    var optionAnswerObj = {};
                    optionAnswerObj.Name = answerOptionList[i].optons;
                    optionAnswerObj.Question__c = '';
                    optionAnswerObj.isValid__c = answerOptionList[i].isValid;
                    optionAnswerList.push(optionAnswerObj);
                }
            }
            console.log('optionAnswerList-->> '+JSON.stringify(optionAnswerList));
            if(!$A.util.isEmpty(optionAnswerList) && optionAnswerList != undefined && !$A.util.isEmpty(questionName) && questionName != undefined) {
                /* Event Handle On The CommunitiesMenus Component */
                var refreshHome = c.getEvent("refreshHome");
                refreshHome.setParams({
                    "questionName" : questionName,
                    "optionAnswerList" : optionAnswerList,
                });
                refreshHome.fire();
            }
        }
    },
    /* For the Add Question Section End */
})