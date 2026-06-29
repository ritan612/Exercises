import { LightningElement, wire, api, track } from 'lwc';
import getAccountsFilter from '@salesforce/apex/AccountServices.getAccountsFilter';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getPicklistValuesByRecordType } from 'lightning/uiRecordApi';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import RECORD_TYPE_FIELD from '@salesforce/schema/Account.RecordTypeId';

export default class AccountFilter extends LightningElement {
    @api recordId;

    accounts = [];
    errors;
    recordTypeId;
    
    @track selectedRating = 'All'; 
    @track dynamicPicklistOptions = [];

    @wire(getRecord, { recordId: '$recordId', fields: [RECORD_TYPE_FIELD] })
    wiredAccount({ error, data }) {
        if (data) {
            this.recordTypeId = getFieldValue(data, RECORD_TYPE_FIELD);
        } else if (error) {
            this.errors = error;
        }
    }

    @wire(getPicklistValuesByRecordType, { 
        objectApiName: ACCOUNT_OBJECT, 
        recordTypeId: '$recordTypeId' 
    })
    wiredPicklistValues({ error, data }) {
        if (data) {
            const ratingValues = data.picklistFieldValues.Rating.values;
            
            let options = [{ label: 'All Accounts', value: 'All' }];
            
            ratingValues.forEach(picklistOption => {
                options.push({
                    label: picklistOption.label,
                    value: picklistOption.value
                });
            });

            this.dynamicPicklistOptions = options;
        } else if (error) {
            this.errors = error;
        }
    }

    @wire(getAccountsFilter)
    wired_getAccountsFilter({ error, data }) {
        if (data) {
            this.accounts = data;
            this.errors = undefined;
        } else if (error) {
            this.accounts = undefined;
            this.errors = error;
        }
    }

    handleChange(event) {
        this.selectedRating = event.detail.value;
    }

    get FilteredAccount() {
        if (!this.accounts) {
            return [];
        }
        if (this.selectedRating === 'All') {
            return this.accounts;
        }
        return this.accounts.filter(acc => acc.Rating === this.selectedRating);
    }
}
