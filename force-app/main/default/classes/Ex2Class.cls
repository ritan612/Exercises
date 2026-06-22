public with sharing class Ex2Class {
    
    public static void countContactOccurences(List<Contact> contactList, Map<Id, Contact> oldMap) {
        Set<Id> accountIds = new Set<Id>();
        if (contactList == null) {
            return; 
        }
        
       for (Contact con : contactList) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
            if (oldMap != null && oldMap.containsKey(con.Id)) {
                Contact oldCon = oldMap.get(con.Id);
                if (oldCon.AccountId != null && oldCon.AccountId != con.AccountId) {
                    accountIds.add(oldCon.AccountId);
                }
            }
        }

        if (accountIds.isEmpty()) {
            return;
        }
        
        Map<Id, Account> accountsToUpdateMap = new Map<Id, Account>();
        for (Id accId : accountIds) {
            accountsToUpdateMap.put(accId, new Account(Id = accId, Number_Of_Contacts__c = 0));
        }
        List<AggregateResult> queryResults = [
            SELECT AccountId, COUNT(Id) totalCount 
            FROM Contact 
            WHERE AccountId IN :accountIds 
            AND (FirstName = null OR LastName = 'Smith') 
            GROUP BY AccountId
        ];
        
        for (AggregateResult result : queryResults) {
            Id accId = (Id)result.get('AccountId');
            Integer count = (Integer)result.get('totalCount');
            
            if (accountsToUpdateMap.containsKey(accId)) {
                accountsToUpdateMap.get(accId).Number_Of_Contacts__c = count;
            }
        }
        
        // Step 6: Save the updated Accounts to the database
        if (!accountsToUpdateMap.isEmpty()) {
            update accountsToUpdateMap.values();
        }
    }
}