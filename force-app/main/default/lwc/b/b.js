import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import COMPONENT_COMMUNICATION_CHANNEL from '@salesforce/messageChannel/messageChannelName__c';
import getOpps from '@salesforce/apex/OpportunityController.getOpportunitiesByAccount';

export default class ComponentB extends LightningElement {
    receivedMessage = ''; 
    subscription = null;
    oppList = [];

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

    handleMessage(payload) {
        console.log('Received Payload: ', payload);
        this.receivedMessage = payload.message;
        console.log('received message =', this.receivedMessage);
    }
    
    @wire(getOpps, { accountId: '$receivedMessage' })
    wiredOpportunities({ error, data }) {
        if (data) {
            this.oppList = data;
            console.log('data fetcheddddddd:', JSON.parse(JSON.stringify(this.oppList)));
        } else if (error) {
            console.error('Error fetching opportunities: ', error);
            this.oppList = [];
        }
    }
}
