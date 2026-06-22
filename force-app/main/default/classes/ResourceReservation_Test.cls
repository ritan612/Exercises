@isTest
public class ResourceReservation_Test {

    @testSetup
    static void setupData() {
        Datetime startDate = Datetime.newInstance(2008, 2, 5, 8, 30, 12);
        Datetime endDate = Datetime.newInstance(2028, 2, 5, 8, 30, 12);
        Resource_reservation__c res = new Resource_reservation__c(Name='Test', Start_date_of_use__c= startDate,End_date_of_use__c= endDate,Reserved_resource__c= 'Room1');
        insert res;
    }

    @isTest
    public static void verifyReservation(){
        
        Resource_reservation__c res = [SELECT Id, Reserved_resource__c, Start_date_of_use__c, End_date_of_use__c FROM Resource_reservation__c LIMIT 1];
        
        Test.startTest();
        
        Datetime startDate = Datetime.newInstance(2008, 2, 5, 8, 30, 12);
        Datetime endDate = Datetime.newInstance(2028, 2, 5, 8, 30, 12);
        
        Resource_reservation__c res1 = new Resource_reservation__c(Name='Test2', Start_date_of_use__c= startDate,End_date_of_use__c= endDate,Reserved_resource__c= 'Room2');
        insert res1;

        Resource_reservation__c res2 = new Resource_reservation__c(Name='Test2', Start_date_of_use__c= startDate,End_date_of_use__c= endDate,Reserved_resource__c= 'Room1');
        
        res1.Reserved_resource__c ='Room1';
        update res1;
        
        Test.stopTest();

    }
}