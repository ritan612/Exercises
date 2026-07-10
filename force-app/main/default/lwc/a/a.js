import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import COMPONENT_COMMUNICATION_CHANNEL from '@salesforce/messageChannel/messageChannelName__c';

export default class ComponentA extends LightningElement {
    @wire(MessageContext) messageContext;

    handleButtonClicked() {
        const accountIdValue = this.template.querySelector('lightning-record-picker').value;
        const payload = {message:accountIdValue};
        publish(this.messageContext, COMPONENT_COMMUNICATION_CHANNEL, payload);
    }
}
