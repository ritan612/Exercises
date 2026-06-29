public with sharing class Identifier {
    public static void generateOfferIdentifiers(List<Offer__c> newList, Map<Id, Offer__c> oldmap) {
        Set<Id> oppIds = new Set<Id>();

        for(Offer__c off: newList){
            if(oldMap == null || oldmap.get(off.Id).Opportunity__c != off.Opportunity__c){
                if(off.Opportunity__c !=null){
                    oppIds.add(off.Opportunity__c);
                }
            }
        }

        if(oppIds.isEmpty()){
            return;
        }

        Map<Id,Opportunity> parentOppsMap = new Map<Id, Opportunity>([
            SELECT Id, Identifier__c
            FROM Opportunity
            WHERE Id IN : oppIds
        ]);

        Map<Id, Integer> oppCurrentCountMap = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT Opportunity__c, COUNT(Id) totalCount
            FROM Offer__c
            WHERE Opportunity__c IN : oppIds
            GROUP BY Opportunity__c
        ]) {
            oppCurrentCountMap.put((Id)ar.get('Opportunity__c'), (Integer)ar.get('totalCount'));
        }

        for(Offer__c off : newList){
            if(oldmap == null || oldmap.get(off.Id).Opportunity__c != off.Opportunity__c){
                if(off.Opportunity__c != null && parentOppsMap.containsKey(off.Opportunity__c)){
                    String oppPrefix = parentOppsMap.get(off.Opportunity__c).Identifier__c;
                    if(oppPrefix == null) oppPrefix = '';

                    Integer nextNumber = 0;
                    if(oppCurrentCountMap.containsKey(off.Opportunity__c)){
                        nextNumber = oppCurrentCountMap.get(off.Opportunity__c);
                    }

                    String paddedNumber = String.valueOf(nextNumber).leftPad(3, '0');

                    off.Identifier__c = oppPrefix + '-' + paddedNumber;

                    oppCurrentCountMap.put(off.Opportunity__c, nextNumber + 1);
                }
            }
        }

    }
}