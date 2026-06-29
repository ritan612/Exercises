public with sharing class AccountImperativeCallController {
    @AuraEnabled(cacheable=true)
    
    public static List<Account> getRecentAccount(){
        return [
        SELECT Id, Name, CreatedById 
        FROM Account 
        ORDER BY Id DESC 
        LIMIT 10
        ];
    }
    
    @AuraEnabled(cacheable=true)
    
    public static List<Account> getHotAccount(){
        return [
        SELECT Id, Name, Rating
        FROM Account 
        WHERE Rating = 'Hot'
        ];
    }

    @AuraEnabled(cacheable=true)
    
    public static List<Account> getAccountWithoutPhone(){
        return [
        SELECT Id, Name, Phone
        FROM Account
        WHERE Phone = NULL OR Phone = ''
        ];
    }
    
}