import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    greetparent;
    changegreeting(event){
        this.greetparent=event.target.value;
        console.log(event.target.value);
        console.dir(event);
    }
}