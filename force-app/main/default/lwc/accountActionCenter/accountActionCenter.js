import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import getRecentAccount from '@salesforce/apex/AccountImperativeCallController.getRecentAccount';
import getHotAccount from '@salesforce/apex/AccountImperativeCallController.getHotAccount';
import getAccountWithoutPhone from '@salesforce/apex/AccountImperativeCallController.getAccountWithoutPhone';

export default class AccountActionCenter extends NavigationMixin(LightningElement) {
    accounts; 
    selectedAccountId; 
    selectedAccountName = ''; 
    isDetailsVisible = false; 
    isEditingDescription = false; 
    currentFilter = 'RECENT'; 

    wiredRecentResult;
    wiredHotResult;
    wiredNoPhoneResult;

    @wire(getRecentAccount)
    wiredRecent(result) {
        this.wiredRecentResult = result;
        if (this.currentFilter === 'RECENT') {
            this.accounts = result.data;
        }
    }

    @wire(getHotAccount)
    wiredHot(result) {
        this.wiredHotResult = result;
        if (this.currentFilter === 'HOT') {
            this.accounts = result.data;
        }
    }

    @wire(getAccountWithoutPhone)
    wiredNoPhone(result) {
        this.wiredNoPhoneResult = result;
        if (this.currentFilter === 'NO_PHONE') {
            this.accounts = result.data;
        }
    }

    handleLoadRecentAccounts() {
        this.currentFilter = 'RECENT';
        this.resetDetails();
        this.accounts = this.wiredRecentResult.data;
    }

    handleLoadHotAccounts() {
        this.currentFilter = 'HOT';
        this.resetDetails();
        this.accounts = this.wiredHotResult.data;
    }

    handleLoadAccountsWithoutPhone() {
        this.currentFilter = 'NO_PHONE';
        this.resetDetails();
        this.accounts = this.wiredNoPhoneResult.data;
    }

    get accountDetailsHeader() {
        return this.selectedAccountName + ' Details';
    }

    handleSelectAccount(event) {
        this.selectedAccountId = event.target.dataset.id;
        debugger;
        
        let foundAccount = this.accounts.find(acc => acc.Id === this.selectedAccountId);
        if (foundAccount) {
            this.selectedAccountName = foundAccount.Name;
        }

        this.isDetailsVisible = true;
        this.isEditingDescription = false;
    }

    navigateToAccount() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.selectedAccountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }

    handleEnableEdit() {
        this.isEditingDescription = true;
    }

    handleCancelEdit() {
        this.isEditingDescription = false;
    }

    // handleSuccess() {
    //     this.isEditingDescription = false;

    //     if (this.currentFilter === 'RECENT') {
    //         refreshApex(this.wiredRecentResult).then(() => {
    //             this.accounts = this.wiredRecentResult.data;
    //         });
    //     } else if (this.currentFilter === 'HOT') {
    //         refreshApex(this.wiredHotResult).then(() => {
    //             this.accounts = this.wiredHotResult.data;
    //         });
    //     } else if (this.currentFilter === 'NO_PHONE') {
    //         refreshApex(this.wiredNoPhoneResult).then(() => {
    //             this.accounts = this.wiredNoPhoneResult.data;
    //         });
    //     }
    // }

    resetDetails() {
        this.isDetailsVisible = false;
        this.isEditingDescription = false;
        this.selectedAccountName = '';
        this.selectedAccountId = undefined;
    }
}
