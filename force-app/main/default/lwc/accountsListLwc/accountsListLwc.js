import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class AccountsListLwc extends LightningElement {

    maxRecords = 10; 

    @wire(getAccounts, { maxRecords: '$maxRecords' }) 
    accounts;

    handleInputChange(event) {
        const value = event.target.value;
        this.maxRecords = value ? parseInt(value, 10) : 0; 
    }
}
