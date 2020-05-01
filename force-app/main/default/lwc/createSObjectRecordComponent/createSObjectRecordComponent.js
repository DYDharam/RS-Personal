import { LightningElement,api,wire,track } from 'lwc';
import getAccountList from '@salesforce/apex/AccountDetailComponentController.getAccountList';
import delSelectedAccount from '@salesforce/apex/AccountDetailComponentController.deleteContacts';
import findAllContactsRelatedToAccounts from '@salesforce/apex/AccountDetailComponentController.findAllContactsRelatedToAccounts';
import { NavigationMixin } from 'lightning/navigation';
// importing to show toast notifictions
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
// importing to refresh the apex if any record changes the datas
import {refreshApex} from '@salesforce/apex';
export default class MyLwcComponent extends NavigationMixin(LightningElement) {
    @api recordId;
    @track showLoadingSpinner = true;
    @track isSelectedAccountAvailable = false;
    refreshTable;
    @track actionsButton = [
        { label: 'Add Contact', name: 'add_contact', 'iconName': 'action:add' },
        { label: 'View', name: 'view', 'iconName': 'action:preview' },
        { label: 'Edit', name: 'edit', 'iconName': 'action:edit' },
        { label: 'Delete', name: 'delete', 'iconName': 'action:delete' },
    ];
    @track accountColumns = [
        {label: 'Name', fieldName: 'Name', type: 'text', sortable: true},
        {label: 'Date', fieldName: 'CreatedDate', type: 'date', sortable: true},
        {label: 'Actual Date', fieldName: 'CreatedDate', type: 'date-local', sortable: true},
        {label: 'Date Formated', fieldName: 'CreatedDate', type: 'date-local', typeAttributes: {month: 'short', day: 'numeric', year: 'numeric'}, sortable: true},
        {label: 'Marks', fieldName: 'NumberOfEmployees', type: 'number',  cellAttributes: { alignment: 'left', class: { fieldName: 'NumberOfEmployeesClass' }}, sortable: true},
        {label: 'Clean Status', fieldName: 'CleanStatus', type: 'text', cellAttributes: { class: { fieldName: 'dietCSSClass' }}, sortable: true},
        {label: 'Mobile', fieldName: 'Mobile', type: 'text', sortable: true},
        {label: 'AnnualRevenue', fieldName: 'AnnualRevenue', type: 'currency', typeAttributes: { currencyCode: 'USD'}, cellAttributes: { class: { fieldName: 'fvtColorCSSClass' }}, sortable: true},
        {label: 'Avg', fieldName: 'NumberOfEmployees', type: 'percent', sortable: true},
        {label: 'In Working', fieldName: 'Working', type: 'boolean', cellAttributes: { class: { fieldName: 'workingCSSClass' }}, sortable: true},
        {label: 'Edit', type : 'button', initialWidth: 200, typeAttributes: {label: 'Edit', name: 'edit_button', title: 'Edit Button', class: {fieldName: 'isShow'}}},
        { type: 'action', typeAttributes: { rowActions: this.actionsButton } } 
    ];
    @track error;
    @track data ;
    @track showContactModal = false;
    @track allSelectedAccounts = [];
    @wire(getAccountList)
    imperativeWiring(result) {
        this.refreshTable = result;
        if(result.data) {
            this.data = result.data;
            this.showLoadingSpinner = false;
            //this.spinnerStatus = 'sls-hide';
        } else {
            this.showLoadingSpinner = false;
            //this.spinnerStatus = 'sls-show';
            window.console.log('Load Error::: ')
        }
    }
    // For Contact DataTable...
    @track contactsData;
    @track contactsColumns = [
        {label: 'Name', fieldName: 'Name', type: 'text', sortable: true},
        {label: 'Date', fieldName: 'CreatedDate', type: 'date', sortable: true}
    ];
    handleRowAction(event) {
        let actionName = event.detail.action.name;
        let row = event.detail.row;
        window.console.log('row ====> ' + row);
        switch (actionName) {
            case 'view':
                    this.viewCurrentRecord(row);
                break;
            case 'edit':
                this.editCurrentRecord(row);
                break;
            case 'edit_button':
                this.showLoadingSpinner = true;
                this.editCurrentRecord(row);
                break;
            case 'delete':
                this.deleteAccountRecord(row);
                break;
            case 'add_contact':
                this.createContactRecord(row);
                break;
        }
    }
    viewCurrentRecord(row) {
        window.console.log('row ====> ' + JSON.stringify(row));
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                actionName: 'view',
            },
        });
    }
    editCurrentRecord(row) {
        window.console.log('row ====> ' + JSON.stringify(row));
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                actionName: 'edit',
            },
        });
        this.showLoadingSpinner = false;
    }
    deleteAccountRecord(currentRow) {
        let currentRecord = [];
        currentRecord.push(currentRow.Id);
        //this.showLoadingSpinner = true;
        window.console.log('currentRow ====> ' + JSON.stringify(currentRow));
        // calling apex class method to delete the selected contact
        delSelectedAccount({listAccountIds: currentRecord})
        .then(result => {
            window.console.log('result ====> '+result);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: 'Account Deleted Successfully!!',
                variant: 'success'
            }),);
            refreshApex(this.refreshTable); 
            this.showLoadingSpinner = false;
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!',
                message: JSON.stringify(error),
                variant: 'error'
            }),);
        })
    }
    // For creating the Contact record under the Account.
    createContactRecord(row) {
        window.console.log('row ====> ' + JSON.stringify(row));
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                defaultFieldValues: {
                    "AccountId" : row.Id
                },
                actionName: 'new',
                nooverride: '1'
            }
        });
    }
    // Seleted Account Details.
    onRowSelectionJs(event) {
        const allSelectedAccounts = event.detail.selectedRows;
        this.allSelectedAccounts = allSelectedAccounts;
        if(allSelectedAccounts.length > 0) {
            this.isSelectedAccountAvailable = true;
        } else {
            this.isSelectedAccountAvailable = false;
        }
    }
    // Bydefault Modal not visible.
    openContactModal() {
        this.showContactModal = true
    }
    closeContactModal() {
        this.showContactModal = false
    }
    closeContactModal() {
        this.showContactModal = false;
    }
    viewContacts(event) {
        this.showContactModal = true;
        var allSelectedAccounts = this.allSelectedAccounts;
        const getAllAccountsDetails = allSelectedAccounts;
        findAllContactsRelatedToAccounts({ getAllAccountsDetails })
            .then(result => {
            window.console.log('result:: ' + JSON.stringify(result));
            this.contactsData = result;
            this.error = undefined;
            //this.spinnerStatus = 'sls-hide';
        })
        .catch(error => {
            this.errors = error;
            this.contacts = undefined;
        });
    }
}