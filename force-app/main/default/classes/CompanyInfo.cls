/**
* ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
* Class Name      : CompanyInfo
* Author          : Rita Nassar
* Created Date    : Jul 10, 2026
* Last Modified By: Rita Nassar
* Last Modified On: Jul 13, 2026
* Description     : This class implements for an apex callout that retrieve ; logo , nbr of employees,
*  foundation date, address, biography from company website and fill them in the company information.
*  
* Change History  :
*  Date          │   Author     │   Change
* ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
*  Jul 10, 2026  │ Rita Nassar  │ Initial version
* ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
*  Jul 13, 2026  │ Rita Nassar  │ Fixed version
* ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
*/

public with sharing class CompanyInfo {
    
    private static final String named_credential = 'callout:Lead_Named_Credential';
    
    private static final Integer maxLeadPerJob = 90;
    
    public static void processLead (List<Lead> newLeadsList , Map<Id, Lead> oldMap ){
        Set<Id> leadIds = new Set<Id>(); 
        for(Lead newLead : newLeadsList){
            if (String.isBlank(newLead.Website)) {
                continue;
            }
            Lead oldLead = oldMap == null ? null : oldMap.get(newLead.Id);
            Boolean isInsert = oldLead == null;
            Boolean websiteChange = oldLead != null && oldLead.Website != newLead.Website;
            
            if( isInsert || websiteChange){
                leadIds.add(newLead.Id);
            }
        }
        if(!leadIds.isEmpty()){
            System.enqueueJob(new LeadInfoQueueable(new List<Id>(leadIds)));
        }
    }
    
    public static HttpResponse doHTTPRequest ( String endpoint, String method, Map<string,String> header, String body ) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        if(header != null){
            for (String headerKey : header.keySet()) {
                req.setHeader(headerKey, header.get(headerKey));
            }
        }
        if(body != null){
            req.setBody(body);
        }
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        return res;
    }
    
    
    public static HttpResponse getLeadInfo(String website){
        String query = 'SELECT logoUrl__c, NumberOfEmployees, Foundation_date__c, BillingAddress, Description FROM Account WHERE Website =\'' + String.escapeSingleQuotes(website) + '\'';
        String encodedQuery = EncodingUtil.urlEncode(query, 'UTF-8');
        String dataEndpoint = named_credential+'/services/data/v54.0/query/?q=' + encodedQuery;
        
        Map<String, String> headers = new Map<String, String>{
            'Accept' => 'application/json'
        };
        
        HttpResponse response = doHTTPRequest(dataEndpoint, 'GET', headers, null);
        
        return response;
    }
    
    
    
    public class LeadInfoQueueable implements Queueable, Database.AllowsCallouts {
        
        private List<Id> allLeadIds;
        
        public LeadInfoQueueable(List<Id> leadIds) {
            this.allLeadIds = leadIds;
        }
        
        public void execute(QueueableContext context) {
            
            List<Id> currentIds = new List<Id>();
            List<Id> remainingIds = new List<Id>();
            
            for (Integer i = 0; i < this.allLeadIds.size(); i++) {
                Id currentId = this.allLeadIds.get(i);
                
                if (i < maxLeadPerJob) {
                    currentIds.add(currentId);
                } else {
                    remainingIds.add(currentId);
                }
            }
            
            Map<Id, Lead> leadRecordsMap = new Map<Id, Lead>([
            SELECT Id, Website, NumberOfEmployees , Foundation_date__c, Address , Company_Biography__c, Company_Logo__c
            FROM Lead 
            WHERE Id IN :currentIds
            ]);
            
            List<Lead> leadsToUpdateList = new List<Lead>();
            
            for (Id leadId : currentIds) {
                Lead myLead = leadRecordsMap.get(leadId);
                
                if (myLead != null && myLead.Website != null && myLead.Website != '') {
                    HttpResponse apiResponse = CompanyInfo.getLeadInfo(myLead.Website);
                    
                    if (apiResponse.getStatusCode() == 200) {
                        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(apiResponse.getBody());
                        List<Object> recordsList = (List<Object>) jsonMap.get('records');
                        
                        if (!recordsList.isEmpty()) {
                            Map<String, Object> firstRecord = (Map<String, Object>) recordsList.get(0);
                            
                            if (firstRecord.get('NumberOfEmployees') != null) {
                                myLead.NumberOfEmployees = Integer.valueOf(firstRecord.get('NumberOfEmployees'));
                            }
                            
                            if (firstRecord.get('Description') != null) {
                                myLead.Company_Biography__c = String.valueOf(firstRecord.get('Description'));
                            }
                            
                            if (firstRecord.get('logoUrl__c') != null) {
                                myLead.Company_Logo__c = String.valueOf(firstRecord.get('logoUrl__c'));
                            }
                            
                            if (firstRecord.get('Foundation_date__c') != null) {
                                myLead.Foundation_date__c = Date.valueOf(String.valueOf(firstRecord.get('Foundation_date__c')));
                            }
                            
                            if (firstRecord.get('BillingAddress') != null) {
                                Map<String, Object> addressMap = (Map<String, Object>) firstRecord.get('BillingAddress');
                                
                                if (addressMap.get('street') != null) {
                                    myLead.Street = String.valueOf(addressMap.get('street'));
                                }
                                if (addressMap.get('city') != null) {
                                    myLead.City = String.valueOf(addressMap.get('city'));
                                }
                                if (addressMap.get('state') != null) {
                                    myLead.State = String.valueOf(addressMap.get('state'));
                                }
                                if (addressMap.get('postalCode') != null) {
                                    myLead.PostalCode = String.valueOf(addressMap.get('postalCode'));
                                }
                                if (addressMap.get('country') != null) {
                                    myLead.Country = String.valueOf(addressMap.get('country'));
                                }
                            }
                            
                            leadsToUpdateList.add(myLead);
                        }
                    }
                }
            }
            
            
            if (!leadsToUpdateList.isEmpty()) {
                update leadsToUpdateList;
            }
            
            if (!remainingIds.isEmpty()) {
                LeadInfoQueueable next = new LeadInfoQueueable(remainingIds);
                System.enqueueJob(next);
            }
        }
    }
    
}