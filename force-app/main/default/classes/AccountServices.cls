public with sharing class AccountServices {
    @AuraEnabled(cacheable = true)
    
    public static List<Account> getAccountsFilter() {
        List<Account> accounts =[SELECT Id, Name, Industry, Rating, Phone FROM Account ORDER BY CreatedDate DESc Limit:10];
        return accounts;
    }
}