public with sharing class OppDetailsPDF {
    public static void sendEmail(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        
        Set<Id> qualifiedOppIds = new Set<Id>();
        for(Opportunity opp : newList){
            Opportunity oldOpp = (oldMap != null) ? oldMap.get(opp.Id) : null;
            if(opp.StageName == 'Closed Won' &&  oldOpp.StageName != 'Closed Won'){
                qualifiedOppIds.add(opp.Id);
            }
        }

        if (qualifiedOppIds.isEmpty()) {
            return;
        }


        Map<Id, List<String>> oppIdToEmailsMap = new Map<Id, List<String>>();
        
        for (OpportunityTeamMember otm : [
            SELECT OpportunityId, User.Email 
            FROM OpportunityTeamMember 
            WHERE OpportunityId IN :qualifiedOppIds AND User.Email != null
        ]) {
            if (!oppIdToEmailsMap.containsKey(otm.OpportunityId)) {
                oppIdToEmailsMap.put(otm.OpportunityId, new List<String>());
            }
            oppIdToEmailsMap.get(otm.OpportunityId).add(otm.User.Email);
        }

        System.enqueueJob(new sendWonOppPdfQueueable(qualifiedOppIds,oppIdToEmailsMap));
    }
}