/**
@Description: this class is for the resource reservation object , when someone want to reserve a resource this class will check if this resource is reserved in this time if yes it will give an error to change time and if it not it will give the reservation
@Author: Rita Nassar
@Company: EI-Technologies
@Last Modified : 19-06-2026
@Last Modified By  : Rita Nassar
@Test Class: ResourceReservation_Test
*/
public with sharing class ResourceReservation {
    
    // method to check the reservation if it is available
    public static void checkReservation(List<Resource_reservation__c> newList, Map<Id, Resource_reservation__c> oldmap){

        //Set string for the reserved resource
        Set<String> resourceReservation = new Set<String>();
        //DateTime Min And Max to use them in the query 
        Datetime Min = Datetime.now();
        Datetime Max = Datetime.now();

        // for loop in the newList if insert or Update -> add the reserved resource to the Set resourceReservation
        for (Resource_reservation__c res : newList){
            if(oldMap == null || oldmap.get(res.Id).Reserved_resource__c != res.Reserved_resource__c || oldmap.get(res.Id).Start_date_of_use__c != res.Start_date_of_use__c || oldmap.get(res.Id).End_date_of_use__c != res.End_date_of_use__c){
                resourceReservation.add(res.Reserved_resource__c);
            }
            //Define the Min And Max
            if(res.Start_date_of_use__c < Min){
                Min=res.Start_date_of_use__c;
            }
            if(res.End_date_of_use__c > Max){
                Max=res.End_date_of_use__c;
            }
        }

        //if resourceReservation not empty
        if(!resourceReservation.isEmpty()){

            //Query retrieve all the reserved resource where the reserved resource are in the resourceReservation and between Min And Max
            List<Resource_reservation__c> query=[
                    SELECT Start_date_of_use__c, End_date_of_use__c, Reserved_resource__c 
                    FROM Resource_reservation__c 
                    WHERE Reserved_resource__c IN : resourceReservation
                    AND (Start_date_of_use__c >= :Min )
                    AND (End_date_of_use__c <= :Max)
                     ];

            //loop each res in newlist in the query 
            for(Resource_reservation__c res : newList){
                for(Resource_reservation__c all: query){
                    
                    //if same reserved resource
                    if(res.Reserved_resource__c == all.Reserved_resource__c){
                        
                        //check if the date is in use ( existing start date <= new start date < existing end date OR existing start date < new end date <= existing end date)
                        if((res.Start_date_of_use__c >= all.Start_date_of_use__c && res.Start_date_of_use__c < all.End_date_of_use__c) || (res.End_date_of_use__c > all.Start_date_of_use__c && res.End_date_of_use__c <= all.End_date_of_use__c)){
                            // if true add Error
                            res.addError('this resource is in use in this time , choose another time');
                        }
                        //else continue
                        else {
                            continue;
                        }
                        
                    }
                }
                
            }

        }

    }
}