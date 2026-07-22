public with sharing class sendWonOppPdfQueueable implements Queueable, Database.AllowsCallouts {
    
    private Set<Id> recordIds;
    private Map<Id, List<String>> emailMap;
    OrgWideEmailAddress owe = [SELECT Id,Address FROM OrgWideEmailAddress where Address = 'rita.nassar@eit-mena.com' limit 1];
    public sendWonOppPdfQueueable (Set<Id> recordIds, Map<Id,List<String>> emailMap){
        this.recordIds = recordIds;
        this.emailMap = emailMap;
    }

    public void execute(QueueableContext context){
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Id oppId : recordIds) {

            List<String> recipientEmails = emailMap.get(oppId);

            PageReference pdfPage = Page.OpportunityDetails; 
            pdfPage.getParameters().put('id', oppId);
            Blob pdfBlob ;
            if(Test.isRunningTest()){
                pdfBlob = Blob.valueOf('Dummy Text');
            }else {
            pdfBlob= pdfPage.getContent();
            }
            
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('Opportunity_Details_' + oppId + '.pdf');
            attachment.setBody(pdfBlob);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(recipientEmails);
            mail.setOrgWideEmailAddressId(owe.Id);
            mail.setSubject('Closed Won: Opportunity Details PDF');
            mail.setPlainTextBody('Hello Team,\n\nPlease find attached the PDF details for the newly closed opportunity.\n\nBest regards,\nSalesforce System');
            mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{ attachment });

            emailsToSend.add(mail);
        }

        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }
}