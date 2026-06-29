public with sharing class AccountController {
    public static string createAccount(String accountName){
        Account acc = new Account(Name=accountName);
        insert acc;
        return acc.Id;
    }
    @AuraEnabled(cacheable = true)
    public static List<Account> getAccounts(Integer maxRecords) {
        List<Account> accounts =[SELECT Id, Name FROM Account ORDER BY CreatedDate DESc Limit:maxRecords];
        return accounts;
    }
}