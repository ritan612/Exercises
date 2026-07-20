import { LightningElement, api, wire } from 'lwc';
import getProductImages from '@salesforce/apex/ImageService.getProductImages';

export default class Pictures extends LightningElement {
    @api recordId; 
    imagesList = []; 
    hasImages = false; 

    @wire(getProductImages, { productId: '$recordId' })
    wiredImagesResult({ error, data }) {
        if (data) {
            this.imagesList = data.map((url, index) => {
                return {
                    id: 'image-' + index,
                    url: url
                };
            });
            this.hasImages = this.imagesList.length > 0;
        } else if (error) {
            console.error('Something went wrong fetching the images: ', error);
            this.imagesList = [];
            this.hasImages = false;
        }
    }
}