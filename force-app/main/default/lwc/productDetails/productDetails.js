import { LightningElement ,api} from 'lwc';
import LightningModal from 'lightning/modal';

export default class ProductDetails extends LightningModal  {
    @api payload;
    header='Product Details';
    connectedCallback() {
        console.log(JSON.stringify(this.payload));
    }

    get isGenerator() {
    return this.payload?.recordTypeDeveloperName === 'Generators';
}
}