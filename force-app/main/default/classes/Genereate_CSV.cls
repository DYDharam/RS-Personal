public class Genereate_CSV {
    @AuraEnabled
    public static Blob generateCSV_Apex() {
        try {
            List<Account > acclist = [Select id,name , CreatedDate , lastModifiedDate from Account limit 10];
            string header = 'Record Id, Name , Created Date, Modified Date \n';
            string finalstr = header ;
            for(Account a: acclist) {
                string recordString = '"'+a.id+'","'+a.Name+'","'+a.CreatedDate+'","'+a.LastModifiedDate +'"\n';
                finalstr = finalstr +recordString;
            }
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            
            /*
             * For inserting the Attachment.
             * 
            Attachment attachment = new Attachment();
            attachment.OwnerId = UserInfo.getUserId();
            attachment.ParentId = '0017F00001YwiLm'; // ID of the Object.
            attachment.IsPrivate = false;
            attachment.Name = 'CSS.csv';
            attachment.Body = csvBlob;
            insert attachment;
            */
            
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String[] toAddresses = new list<string> {'infodharmendra2020@gmail.com'};
            String subject ='Account CSV';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            email.setPlainTextBody('Account CSV ');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            return csvBlob;
        } catch(Exception Ex) {
            System.debug('Error is : ' + Ex.getMessage() + ' On Line Number : ' + Ex.getLineNumber());
        }
        return null;
    }
}