@RestResource(urlMapping='/showAccountsDetails/*')
global class checkAccount {
	@HttpGet
    global static list<Account> doGet()
    {
        RestRequest req =RestContext.request;
        RestResponse res =RestContext.response;
        list<Account> acc_list = new list<Account>();
        try
        {
            acc_list = [select Id, Name, Phone from Account LIMIT 10];
            return acc_list;
        }
        catch(Exception ex)
        {
            System.debug('Error'+ex.getMessage());
        }
        return acc_list;
    }
}