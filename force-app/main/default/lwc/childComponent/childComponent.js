import { LightningElement} from 'lwc';

export default class ChildComponent extends LightningElement {
    
    sendText() {
        const myEvent = new CustomEvent('message', {detail: 'Hello Child'});
        this.dispatchEvent(myEvent);
    }
}