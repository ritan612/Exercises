import { LightningElement } from 'lwc';

export default class Parent extends LightningElement {
    childOneStatus = 'Deselected';
    childTwoStatus = 'Deselected';

    handleChild(event){
        const {label, selected} = event.detail;
        if(label === 'child one') {
            this.childOneStatus = selected ? 'Selected' : 'Deselected';
        } else if(label === 'child two') {
            this.childTwoStatus = selected ? 'Selected' : 'Deselected';
        }
    }
}
