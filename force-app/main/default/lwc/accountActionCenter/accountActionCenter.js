import { LightningElement } from 'lwc';
import getRecentAccount from '@salesforce/apex/AccountImperativeCallController.getRecentAccount';
import getHotAccount from '@salesforce/apex/AccountImperativeCallController.getHotAccount';
import getAccountWithoutPhone from '@salesforce/apex/AccountImperativeCallController.getAccountWithoutPhone';

export default class AccountActionCenter extends LightningElement {
    accounts;
    error;

    selectedAccountId;
    isDetailsVisible = false;
    isEditingDescription = false;

    async handleLoadRecentAccounts() {
        try {
            this.accounts = await getRecentAccount();
            this.error = undefined;
            this.resetDetails();
        } catch (error) {
            this.accounts = undefined;
            this.error = error;
        }
    }

    async handleLoadHotAccounts() {
        try {
            this.accounts = await getHotAccount();
            this.error = undefined;
            this.resetDetails();
        } catch (error) {
            this.accounts = undefined;
            this.error = error;
        }
    }

    async handleLoadAccountsWithoutPhone() {
        try {
            this.accounts = await getAccountWithoutPhone();
            this.error = undefined;
            this.resetDetails();
        } catch (error) {
            this.accounts = undefined;
            this.error = error;
        }
    }

    handleSelectAccount(event) {
        this.selectedAccountId = event.target.dataset.id;
        this.isDetailsVisible = true;
        this.isEditingDescription = false;
    }

    handleEnableEdit() {
        this.isEditingDescription = true;
    }

    handleCancelEdit() {
        this.isEditingDescription = false;
    }

    handleSuccess() {
        this.isEditingDescription = false;
    }

    resetDetails() {
        this.isDetailsVisible = false;
        this.isEditingDescription = false;
    }
}