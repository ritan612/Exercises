import { LightningElement, wire, api , track} from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import COMPONENT_COMMUNICATION_CHANNEL from '@salesforce/messageChannel/messageChannelName__c';
import getAllProduct from '@salesforce/apex/ProductServices.getAllProduct';
import getGenerator from '@salesforce/apex/ProductServices.getGenerator';
import getParts from '@salesforce/apex/ProductServices.getParts';

import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import PRODUCT_OBJECT from '@salesforce/schema/Product2';
import COUNTRY_FIELD from '@salesforce/schema/Product2.Country_Of_Origin__c';

export default class ShowProduct extends LightningElement {
    @api products; 
    selectedProductId;
    selectedProductName = ''; 
    currentFilter = 'All'; 
    selectedCountry = 'All';

    countryOptions = [];
    

    @track selectedProductIds = [];

    @wire(MessageContext) messageContext;

    handleShowDetails(event) {
        event.preventDefault();
        const productId =event.target.dataset.id;
        const payload = {recordId: productId };
        publish(this.messageContext, COMPONENT_COMMUNICATION_CHANNEL, payload);
    }

    get typeOptions() {
        return [
            { label: 'All', value: 'All' },
            { label: 'Generator', value: 'Generator' },
            { label: 'Parts', value: 'Parts' }
        ];
    }

    @wire(getObjectInfo, { objectApiName: PRODUCT_OBJECT })
    productMetadata;

    @wire(getPicklistValues, { 
        recordTypeId: '$productMetadata.data.defaultRecordTypeId', 
        fieldApiName: COUNTRY_FIELD 
    })
    wiredPicklist({ data }) {
        if (data) {
            const dynamicOptions = data.values.map(picklist => ({
                label: picklist.label,
                value: picklist.value
            }));
            this.countryOptions = [{ label: 'All Countries', value: 'All' }, ...dynamicOptions];
        }
    }

    wiredAllResult;
    wiredGeneratorResult;
    wiredPartsResult;

    @wire(getAllProduct)
    wiredAll(result) {
        this.wiredAllResult = result;
    }

    @wire(getGenerator)
    wiredGenerator(result) {
        this.wiredGeneratorResult = result;
    }

    @wire(getParts)
    wiredParts(result) {
        this.wiredPartsResult = result;
    }

    handleTypeChange(event) {
        this.currentFilter = event.detail.value;
    }

    handleCountryChange(event) {
        this.selectedCountry = event.detail.value;
    }

    get formattedProducts() {
        let activeData = [];

        if (this.currentFilter === 'All' && this.wiredAllResult.data) {
            activeData = this.wiredAllResult.data;
        } else if (this.currentFilter === 'Generator' && this.wiredGeneratorResult.data) {
            activeData = this.wiredGeneratorResult.data;
        } else if (this.currentFilter === 'Parts' && this.wiredPartsResult.data) {
            activeData = this.wiredPartsResult.data;
        }

        return activeData
            .map(pbe => {
                return {
                    id: pbe.Product2Id, 
                    name: pbe.Product2 ? pbe.Product2.Name : '',
                    quantity: 1, 
                    amount: pbe.UnitPrice || 0,
                    country: pbe.Product2 ? pbe.Product2.Country_Of_Origin__c : ''
                };
            })
            .filter(prod => {
                return this.selectedCountry === 'All' || prod.country === this.selectedCountry;
            });
    }

        handleRowSelection(event) {
        const productId = event.target.dataset.id;
        const isChecked = event.target.checked;
        if (isChecked) {
            if (!this.selectedProductIds.includes(productId)) {
                this.selectedProductIds = [...this.selectedProductIds, productId];
            }
        } else {
            this.selectedProductIds = this.selectedProductIds.filter(id => id !== productId);
        }
        console.log('Currently Selected Product IDs:', JSON.stringify(this.selectedProductIds));
    }


}