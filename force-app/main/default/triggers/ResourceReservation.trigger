trigger ResourceReservation on Resource_reservation__c (before insert, before update) {
    new ResourceReservationTriggerHandler().run();
}