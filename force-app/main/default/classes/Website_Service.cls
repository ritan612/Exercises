public with sharing class Website_Service {
    @AuraEnabled(cacheable=true)
    public static OpportunityData getOppDetails(Id oppId) {
        OpportunityData dto = new OpportunityData();
        Opportunity opp = [SELECT Name, Account.Name , Account.PersonEmail, Account.Phone FROM Opportunity WHERE Id = :oppId LIMIT 1];
        dto.companyName = opp.Account != null ? opp.Account.Name : '';
        dto.contactName = opp.Name;
        dto.email = opp.Account != null ? opp.Account.PersonEmail : '';
        dto.phone = opp.Account != null ? opp.Account.Phone : '';
        return dto;
    }

    public class OpportunityData {
        @AuraEnabled public String companyName;
        @AuraEnabled public String contactName;
        @AuraEnabled public String email;
        @AuraEnabled public String phone;
    }
}
