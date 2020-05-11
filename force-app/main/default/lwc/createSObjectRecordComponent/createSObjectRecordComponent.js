import {LightningElement,api,wire,track} from 'lwc';
import getSObjectPickList from '@salesforce/apex/CreateSObjectDynamicallyCtrl.getSobjectList_Apex';
import getAllFieldsList from '@salesforce/apex/CreateSObjectDynamicallyCtrl.getAllFieldsLWC_Apex';
import saveSobjectRecord from '@salesforce/apex/CreateSObjectDynamicallyCtrl.saveSobjectRecord_Apex';

import { NavigationMixin } from 'lightning/navigation';
// importing to show toast notifictions
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class MyLwcComponent extends NavigationMixin(LightningElement) {
    @track showLoadingSpinner = true; //Used for the Lightning Spinner.
    @track seletedSobjectName; //Selected sObject value in picklist.
    @track sObjectOptions; // This contains list of sObject that is displayed on the picklist.
    @track getAllFieldsList;
    
    @wire(getSObjectPickList)
    imperativeWiring(result) {
        getSObjectPickList()
        .then(result => {
            this.sObjectOptions = result;
            this.showLoadingSpinner = false;
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!',
                message: JSON.stringify(error),
                variant: 'error'
            }),);
            this.showLoadingSpinner = false;
        })
    }
    // After selecting the sObject.
    selectSobject(event) {
        this.showLoadingSpinner = true;
        let sObjectName = event.target.value;
        this.seletedSobjectName = sObjectName;
        // Get all fields and their value using the sObject Name.
        getAllFieldsList({sObjectName : sObjectName, recordId : ''})
        .then(result => {
            //console.log('result:::: ' + JSON.stringify(result));
            this.getAllFieldsList = result;
            this.showLoadingSpinner = false;
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!',
                message: JSON.stringify(error),
                variant: 'error'
            }),);
            this.showLoadingSpinner = false;
        })
    }
    // For the checkbox value true/false
    setCheckBoxTrue(event) {
        let isCheckbox = event.target.checked;
        let fieldLabel = event.target.label;
        let getAllFieldsList = this.getAllFieldsList;
        if(getAllFieldsList.length > 0 && getAllFieldsList) {
            for(var i = 0; i < getAllFieldsList.length; i++) {
                if(getAllFieldsList[i].fieldLabel == fieldLabel && isCheckbox == true) {
                    getAllFieldsList[i].fieldValue = true;
                } else if(getAllFieldsList[i].fieldLabel == fieldLabel && isCheckbox == false) {
                    getAllFieldsList[i].fieldValue = false;
                }
            }
        }
    }
    changeValueFunction(event) {
        let getLabel = event.target.label;
        let getValue = event.target.value;
        let getAllFieldsList = this.getAllFieldsList;
        if(getAllFieldsList.length > 0) {
            for(var i = 0; i < getAllFieldsList.length; i++) {
                if(getAllFieldsList[i].fieldLabel == getLabel) {
                    getAllFieldsList[i].fieldValue = getValue;
                }
            }
        }
    }
    // For creating the record here:
    insertSobjectRecord() {
        let isError = false;
        let errorMessage = '';
        var newListForInsert = [];
        let getAllFieldsList = this.getAllFieldsList;
        console.log('getAllFieldsList::::: ' + JSON.stringify(getAllFieldsList));
        if(getAllFieldsList.length > 0) {
            for(var i = 0; i < getAllFieldsList.length; i++) {
                if(getAllFieldsList[i].isRequiredField == true && getAllFieldsList[i].fieldValue === '') {
                    isError = true;
                    console.log('Missing Required Fields::::');
                    errorMessage = 'Required Field Missing : ' + getAllFieldsList[i].fieldLabel;
                    //h.notification_message(c, e, h, 'Error Message', msg, 'error');
                    break;
                }
            }
            var strRecordOj = '{';
            for(var i = 0; i < getAllFieldsList.length; i++) {
                if(getAllFieldsList[i].fieldType == 'reference' && getAllFieldsList[i].fieldValue.length > 0) {
                    getAllFieldsList[i].fieldValue = getAllFieldsList[i].fieldValue.Id;
                }
                if(getAllFieldsList[i].fieldValue) {
                    strRecordOj += '"' + getAllFieldsList[i].fieldApiName + '":"' + getAllFieldsList[i].fieldValue + '",';
                }
                
            }
            if(strRecordOj[strRecordOj.length -1] == ',') {
                strRecordOj = strRecordOj.slice(0, -1);
            }
            strRecordOj += '}';
            newListForInsert.push(JSON.parse(strRecordOj));
            
            if(isError === true) {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error!!',
                    message: errorMessage,
                    variant: 'error'
                }),);
            } else {
                console.log('newListForInsert::::: ' + JSON.stringify(newListForInsert));
                this.saveRecord_handler(newListForInsert);
            }
            
        }
    }
    // For ssaving the record helper method.
    saveRecord_handler(newListForInsert) {
        let sObjectListAsString = 'List<' + this.seletedSobjectName + '>';
        let message = 'Your ' + this.seletedSobjectName + ' record inserted successfully!!';
        saveSobjectRecord({sObjectListAsString : JSON.stringify(newListForInsert), typeOfList : sObjectListAsString})
        .then(result => {
            console.log('result:Inserted::: ' + JSON.stringify(result));
            this.showLoadingSpinner = false;
            this.notification_message('Success Message', message, 'success');
            this.selectSobject(event);
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!! saveRecord_handler',
                message: JSON.stringify(error),
                variant: 'error'
            }),);
            this.showLoadingSpinner = false;
        })
    }
    // Notification Message success/failure.
    notification_message(msgHead, message, msgType) {
        this.dispatchEvent(new ShowToastEvent({
            title: msgHead,
            message: message,
            variant: msgType
        }),);
    }
}





/*import { LightningElement,api,wire,track } from 'lwc';
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
}*/