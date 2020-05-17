import { LightningElement, track } from 'lwc';
import recentViewRecords from '@salesforce/apex/RecentViewDynamicallyCtrl.getRecentViewItemsDetail_Apex';

export default class RecentlyViewRecordLWC extends LightningElement {
    @track recentViewRecords = [];
    @track isComponentLoaded = true;

    connectedCallback(){
        //this.isComponentLoaded = true;
        recentViewRecords({sObjectName : 'RecentlyViewed'})
        .then(result => {
            console.log('result::: ' + JSON.stringify(result));
            this.recentViewRecords = result;
            this.isComponentLoaded = false;
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!',
                message: JSON.stringify(error),
                variant: 'error'
            }),);
            this.isComponentLoaded = false;
        })
    }
}