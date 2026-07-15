import { LightningElement, wire, api , track} from 'lwc';
import { MessageContext } from 'lightning/messageService';
import getAllProduct from '@salesforce/apex/ProductServices.getAllProduct';
import getGenerator from '@salesforce/apex/ProductServices.getGenerator';
import getParts from '@salesforce/apex/ProductServices.getParts';
import getSingleProductDetails from '@salesforce/apex/ProductServices.getSingleProductDetails';
import getProductCount from '@salesforce/apex/ProductServices.getProductCount';

import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import PRODUCT_OBJECT from '@salesforce/schema/Product2';
import COUNTRY_FIELD from '@salesforce/schema/Product2.Country_Of_Origin__c';
import ProductDetails from 'c/productDetails';


export default class ShowProduct extends LightningElement {
    @api products; 
    selectedProductId;
    selectedProductName = ''; 
    currentFilter = 'All'; 
    selectedCountry = 'All';
    
    countryOptions = [];
    
    
    @track selectedProductIds = [];
    
    pageNumber = 1;
    pageSize = 10;
    totalRecords = 0;
    
    @wire(MessageContext) messageContext;
    
    
    async handleShowDetails(event) {
        event.preventDefault();
        const productId =event.target.dataset.id;
        
        
        const payload = await getSingleProductDetails({id:productId});
        console.log('payload: ',payload);
        const result = await ProductDetails.open({
            size: 'medium',
            payload: payload
        });
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
    
    
    
    @wire(getProductCount, { type: '$currentFilter', country: '$selectedCountry' })
    wiredCount({ data, error }) {
        if (data !== undefined) {
            this.totalRecords = data;
        }
    }
    
    get offsetValue() {
        return (this.pageNumber - 1) * this.pageSize;
    }
    
    get isFirstPage() {
        return this.pageNumber === 1;
    }
    
    get isLastPage() {
        return (this.pageNumber * this.pageSize) >= this.totalRecords;
    }
    
    wiredAllResult;
    wiredGeneratorResult;
    wiredPartsResult;
    
    @wire(getAllProduct, { pageSize: '$pageSize', offsetValue: '$offsetValue', country: '$selectedCountry' })
    wiredAll(result) {
        this.wiredAllResult = result;
    }
    
    @wire(getGenerator, { pageSize: '$pageSize', offsetValue: '$offsetValue', country: '$selectedCountry' })
    wiredGenerator(result) {
        this.wiredGeneratorResult = result;
    }
    
    @wire(getParts, { pageSize: '$pageSize', offsetValue: '$offsetValue', country: '$selectedCountry' })
    wiredParts(result) {
        this.wiredPartsResult = result;
    }
    
    
    handleTypeChange(event) {
        this.currentFilter = event.detail.value;
        this.pageNumber = 1;
    }
    
    handleCountryChange(event) {
        this.selectedCountry = event.detail.value;
        this.pageNumber = 1;
    }
    
    handlePrevious() {
        if (this.pageNumber > 1) {
            this.pageNumber--;
        }
    }
    
    handleNext() {
        if (!this.isLastPage) {
            this.pageNumber++;
        }
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

    // No JS filter needed here anymore because Apex returns already-filtered & paginated data
    return activeData.map(pbe => {
        return {
            id: pbe.Product2Id, 
            name: pbe.Product2 ? pbe.Product2.Name : '',
            quantity: 1, 
            amount: pbe.UnitPrice || 0,
            country: pbe.Product2 ? pbe.Product2.Country_Of_Origin__c : ''
        };
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