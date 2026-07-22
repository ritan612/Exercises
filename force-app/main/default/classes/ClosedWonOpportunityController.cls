public with sharing class ClosedWonOpportunityController {

    public class ResultWrapper {
        @AuraEnabled public Id recordId { get; set; }
        @AuraEnabled public Boolean isSuccess { get; set; }
        
        public ResultWrapper(Id recordId, Boolean isSuccess) {
            this.recordId = recordId;
            this.isSuccess = isSuccess;
        }
    }
    
    @AuraEnabled
    public static ResultWrapper createClosedWonOpp(Id accountId, List<Id> productIds) {
        Account acc = [ SELECT Id, Name FROM Account WHERE Id = :accountId ];

       try {
            Opportunity opp = new Opportunity(
                Name = 'Opportunity - '+ acc.Name +'-'+ System.today().format(),
                AccountId = accountId,
                StageName = 'Closed Won',
                CloseDate = System.today()
                );
            insert opp;
            Id pbId;
            if(test.isRunningTest()) {
                opp = [
                SELECT Id, Pricebook2Id
                FROM Opportunity
                WHERE Id = :opp.Id
            ];
            pbId = [SELECT Id from Pricebook2 WHERE Name = 'Test B2C Pricebook' limit 1].Id;
            opp.Pricebook2Id = pbId;
            update opp;
            }else {
                opp = [
                SELECT Id, Pricebook2Id
                FROM Opportunity
                WHERE Id = :opp.Id
            ];

            pbId = opp.Pricebook2Id;
            }
            
            system.debug('p1: '+opp);
            if (productIds != null) {
                Map<Id,Decimal> unp = new Map<Id,Decimal>();
                Map<Id,Id> productToPricebookEntry = new Map<Id,Id>();
                
                for(PricebookEntry pbe : [SELECT Id,UnitPrice, Product2Id,Pricebook2Id FROM PricebookEntry WHERE Product2Id IN :productIds AND Pricebook2Id = :pbId AND IsActive = true]){
                    system.debug('!!: '+pbe.Pricebook2Id);
                    unp.put(pbe.Product2Id , pbe.UnitPrice);
                    productToPricebookEntry.put(pbe.Product2Id,pbe.Id);
                }
                 system.debug('p2: '+unp);
                List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();

                for (Id p : productIds) {
                    OpportunityLineItem oli = new OpportunityLineItem(
                        OpportunityId = opp.Id,
                        Product2Id = p,
                        PricebookEntryId = productToPricebookEntry.get(p),
                        Quantity = 1,
                        UnitPrice = unp.get(p)
                    );
                    oliList.add(oli);
                }
                 system.debug('p3: '+oliList);

                if (!oliList.isEmpty()) {
                    List<Database.SaveResult> srList = Database.insert(oliList, false);
                    Integer successCount = 0;
                    Integer failureCount = 0;
                    for (Database.SaveResult sr : srList) {
                        if (sr.isSuccess()) {
                            successCount++;
                        } else {
                             for (Database.Error err : sr.getErrors()) {
        System.debug('Error: ' + err.getMessage());
    }
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

