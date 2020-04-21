({
    init: function (c, e, h) {
        c.set('v.mapMarkers', [
            {
                location: {
                    Street: 'Shakti Khand 4',
                    City: 'Indirapuram Ghaziabad',
                    State: 'Uttar Pradesh'
                },

                title: 'Dharmendra House',
                description: 'Near US Cinema'
            }
        ]);
        c.set('v.zoomLevel', 16);
    },
    saveContactUs : function(c, e, h) {
        var contactUsRecord = c.get('v.contactUsInfo');
        if(!$A.util.isEmpty(contactUsRecord.Name) && contactUsRecord.Name != undefined) {
            if(!$A.util.isEmpty(contactUsRecord.Last_Name__c) && contactUsRecord.Last_Name__c != undefined) {
                var isValidEmail = h.checkEmailAddress(c, e, h, contactUsRecord.Email__c);
                if(!$A.util.isEmpty(contactUsRecord.Email__c) && contactUsRecord.Email__c != undefined && isValidEmail == true) {
                    if(!$A.util.isEmpty(contactUsRecord.Description__c) && contactUsRecord.Description__c != undefined) {
                        h.saveContactUs_helper(c, e, h, contactUsRecord);
                    } else {
                        h.toastMessage_helper(c, e, h, 'Error', 'Please any Message', 'Template', '3000', 'info_alt', 'error', 'pester');
                    }
                } else {
                    h.toastMessage_helper(c, e, h, 'Error', 'Please enter a valid Email', 'Template', '3000', 'info_alt', 'error', 'pester');
                }
            } else {
                h.toastMessage_helper(c, e, h, 'Error', 'Please enter Last Name', 'Template', '3000', 'info_alt', 'error', 'pester');
            }
        } else {
            h.toastMessage_helper(c, e, h, 'Error', 'Please enter First Name', 'Template', '3000', 'info_alt', 'error', 'pester');
        }
    },
})