import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class NewClosedWonOpp extends LightningModal {
    @api payload1;
    header = 'Opportunity Created Successfully';

    connectedCallback() {
        console.log(JSON.stringify(this.payload1));
    }

    handleopen() {
        this.close('Navigate');
    }
}