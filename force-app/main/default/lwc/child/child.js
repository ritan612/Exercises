import { LightningElement, api, track} from 'lwc';

export default class Child extends LightningElement {
    @api label;
    @track selected = false;

    get buttonLabel(){
        return this.selected ? 'Deselect' : 'Select';
    }

    handleToggle(){
        this.selected = !this.selected;
        const selectedEvent = new CustomEvent('sample', {
            detail: {label: this.label, selected: this.selected},
        });
        this.dispatchEvent(selectedEvent);
    }
}