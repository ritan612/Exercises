import { LightningElement } from 'lwc';

export default class LifecycleDemo extends LightningElement {
    counter = 0;
    show=true;
    
    increment(){
         this.counter++;
    }

    showHide(){
        this.show = !this.show;
    }

    constructor(){
        super();
        console.log('constructor');
    }

    connectedCallback(){
        console.log('connectedCallback');
    }

    renderedCallback(){
        console.log('renderedCallback');
    }
}