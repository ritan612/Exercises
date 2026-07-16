public with sharing class ClosedWonOpportunityController {

    public class ResultWrapper {
        @AuraEnabled public Id recordId { get; set; }
        @AuraEnabled public Boolean isSuccess { get; set; }
        @AuraEnabled public Integer unitPrice{ get; set;}
        
        public ResultWrapper(Id recordId, Boolean isSuccess) {
            this.recordId = recordId;
            this.isSuccess = isSuccess;
        }
    }
    
    @AuraEnabled
    public static ResultWrapper createClosedWonOpp(Id accountId, List<Id> productIds) {
        Account acc = [ SELECT Id, Name FROM Account WHERE Id = :accountId ];
        Pricebook2 pb = [SELECT Id, Name FROM Pricebook2 WHERE Name='B2C Pricebook' AND IsActive=True];


        try {
            Opportunity opp = new Opportunity(
                Name = 'Opportunity - '+ acc.Name +'-'+ System.today().format(),
                AccountId = accountId,
                StageName = 'Closed Won',
                CloseDate = System.today(),
                Pricebook2Id = pb.Id
            );
            insert opp;



            if (productIds != null) {
                Map<Id,Decimal> unp = new Map<Id,Decimal>();
                
                for(PricebookEntry pbe : [SELECT UnitPrice, Product2Id FROM PricebookEntry WHERE Product2Id =:productIds AND Pricebook2Id =:pb.Id]){
                    unp.put(pbe.Product2Id , pbe.UnitPrice);
                }
                List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();

                for (Id p : productIds) {
                    OpportunityLineItem oli = new OpportunityLineItem(
                        OpportunityId = opp.Id,
                        Product2Id = p,
                        Quantity = 1,
                        UnitPrice = unp.get(p)
                    );
                    oliList.add(oli);
                }

                if (!oliList.isEmpty()) {
                    List<Database.SaveResult> srList = Database.insert(oliList, false);
                    Integer successCount = 0;
                    Integer failureCount = 0;
                    for (Database.SaveResult sr : srList) {
                        if (sr.isSuccess()) {
                            successCount++;
                        } else {
                            failureCount++;
                        }
                    }
                    System.debug('successCount: ' + successCount);
                    System.debug('failureCount: '+ failureCount);
                }
            }
             return new ResultWrapper(opp.Id, true);
        } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
        }
    }
}

