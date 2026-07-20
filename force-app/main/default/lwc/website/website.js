import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getOppDetails from '@salesforce/apex/Website_Service.getOppDetails';

export default class PicklistComponent extends LightningElement {
    recordId;
    companyName = '';
    contactName = '';
    contactEmail = '';
    contactPhone = '';
    
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference){
        if(currentPageReference){
            this.recordId = currentPageReference.state.id;
        }
    }

    @wire(getOppDetails, { oppId: '$recordId' })
    wiredOpportunity({ error, data }) {
        if (data) {
            this.companyName = data.companyName;
            this.contactName = data.contactName;
            this.contactEmail = data.email;
            this.contactPhone = data.phone;
        } else if (error) {
            console.error('Error fetching data via Apex:', error);
        }
    }
}