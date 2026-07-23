public with sharing class AutoCaseFieldAssign {
    
    public static void assignFields(List<Case> newList) {

        List<Case> casesToUpdate = [SELECT Id, SuppliedName, SuppliedEmail, SuppliedCompany, SuppliedPhone 
                                    FROM Case 
                                    WHERE Id IN :newList];


        Set<String> emails = new Set<String>();
        Set<String> companies = new Set<String>();

        for (Case cas : casesToUpdate) {
            if (cas.SuppliedEmail != null) emails.add(cas.SuppliedEmail);
            if (cas.SuppliedCompany != null) companies.add(cas.SuppliedCompany);
        }

        Map<String, Id> emailToContactId = new Map<String, Id>();
        for (Contact con : [SELECT Id, Email FROM Contact WHERE Email IN :emails]) {
            emailToContactId.put(con.Email, con.Id);
        }

        Map<String, Id> companyToAccountId = new Map<String, Id>();
        for (Account acc : [SELECT Id, Name FROM Account WHERE Name IN :companies]) {
            companyToAccountId.put(acc.Name, acc.Id);
        }

        for (Case cas : casesToUpdate) {
            if (emailToContactId.containsKey(cas.SuppliedEmail)) {
                cas.ContactId = emailToContactId.get(cas.SuppliedEmail);
            }
            if (companyToAccountId.containsKey(cas.SuppliedCompany)) {
                cas.AccountId = companyToAccountId.get(cas.SuppliedCompany);
            }
        }

        update casesToUpdate;
    }
}