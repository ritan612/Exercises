import { LightningElement ,wire} from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import COMPONENT_COMMUNICATION_CHANNEL from '@salesforce/messageChannel/messageChannelName__c';

export default class ProductDetails extends LightningElement {
    receivedProductId;

    @wire(MessageContext) messageContext;
    connectedCallback() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                COMPONENT_COMMUNICATION_CHANNEL,
                (payload) => this.handleMessage(payload)
            );
        }
    }

    handleMessage(message) {
        this.receivedProductId = message.recordId;
        console.log('Received Product ID:', this.receivedProductId);
    }
}