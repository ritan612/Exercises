import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    receivedText = '';
    handleMessage(event) {
        this.receivedText = event.detail;
    }
}
