import { LightningElement } from 'lwc';
import customerSatisfaction from '@salesforce/resourceUrl/customerSatisfaction';
export default class WebsiteHeader extends LightningElement {
    logoUrl = customerSatisfaction + '/customerSatisfaction/customerSatisfaction/Logo.png';
    talkIconUrl = customerSatisfaction + '/customerSatisfaction/customerSatisfaction/TalkToUs.svg';
    arrow = customerSatisfaction + '/customerSatisfaction/customerSatisfaction/arrow.svg';
}
