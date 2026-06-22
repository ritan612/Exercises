public with sharing class ContactClass {
    public static void countContactOccurrences(List<Contact> TriggerNew, Map<Id, Contact> oldMap) {
        
        Set<Id> accountIdsToUpdate = new Set<Id>();
        
        if(TriggerNew != null){
            
            for(Contact contact : TriggerNew){
                
                if(contact.AccountId != null && (oldMap == null || 
                   contact.FirstName != oldMap.get(contact.Id).FirstName || 
                   contact.LastName != oldMap.get(contact.Id).LastName || 
                   contact.AccountId != oldMap.get(contact.Id).AccountId)) 
                {
                    accountIdsToUpdate.add(contact.AccountId);
                }
                
            }
            
            if(!accountIdsToUpdate.isEmpty()){
                List<Account> accountList = new List<Account>();
                for(Account acct : [SELECT Id, (SELECT Id FROM Contacts WHERE LastName = 'Smith' OR FirstName = null)
                                    FROM Account WHERE Id = :accountIdsToUpdate]) {
                          acct.Number_Of_Contacts__c = acct.Contacts.size();    
                          accountList.add(acct);
                }
                update accountList;      
            }
        }
    }  
}