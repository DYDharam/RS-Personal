/**
 * An apex class that updates portal user details.
   Guest users are never able to access this page.
 */
public with sharing class MyProfilePageController {

    private User user;
    private boolean isEdit = false;

    public User getUser() {
        return user;
    }

    public MyProfilePageController() {
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
    }

    public Boolean getIsEdit() {
        return isEdit;
    }

    public void edit() {
        isEdit=true;
    }

    public void save() {
        try {
            update user;
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }

    public PageReference changePassword() {
        return Page.ChangePassword;
    }

    public void cancel() {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
    }
    @AuraEnabled
    public static List<Testimonials__c> getTestimonialsRecord_Apex() {
        List<Testimonials__c> testimonialList = new List<Testimonials__c>();
        testimonialList = [SELECT Id, Name, Email__c, Designation__c, Description__c, Image_Url__c, Is_Private__c FROM Testimonials__c LIMIT 100];
        return testimonialList;
    }
    /*
    Method Name : createContactUsRecord
    Purpose     : To save the Contact-Us Record into the apex class.
    */
    @AuraEnabled
    public static Contact_Us__c createContactUsRecord(Contact_Us__c contactUsRecord) {
        try {
            if(contactUsRecord != null) {
                insert contactUsRecord;
                MyProfilePageController.sendMailMethod('infodharmendra2020@gmail.com', 'Aura Lightning Contact', contactUsRecord);
                return contactUsRecord;
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return null;
    }
    public static void sendMailMethod(String mMail ,String mSubject ,Contact_Us__c contactUsRecord){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();   
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(mMail);
        mail.setToAddresses(sendTo);
        mail.setReplyTo('noreply@gmail.com');
        mail.setSenderDisplayName(contactUsRecord.Name);
        mail.setSubject(mSubject);
        mail.setHtmlBody(contactUsRecord.Description__c);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    @AuraEnabled
    public static User getProfileUser_Apex() {
        User usr = new User();
        usr = [Select Id, Name, AboutMe, Email, Description__c, MobilePhone, Phone, Username, Contact.LastName, Contact.Birthdate FROM User Where Email = 'infodharmendra2020@gmail.com' LIMIT 1];
        return usr;
    }
}