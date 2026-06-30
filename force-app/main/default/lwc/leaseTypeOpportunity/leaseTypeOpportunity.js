import { LightningElement ,api, wire, track} from 'lwc';
import { getRecord , getFieldValue} from 'lightning/uiRecordApi';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import LEASE_TYPE_FIELD from '@salesforce/schema/Opportunity.LeaseType__c';


export default class LeaseTypeOpportunity extends LightningElement {
    @api recordId;
    opportunity;
    stageName;
    leaseType;
    @track showFileUploade = false;

    @track fileData;
  @track fileName;
  @track filePreviewUrl;
  @track isUploading = false;
  @track status;
  @track recordId;
    
    @wire(getRecord, {recordId: '$recordId', fields: [STAGE_FIELD, LEASE_TYPE_FIELD]})
    wiredOpportunity ({error, data}){
        if(data){
            this.opportunity = data;
            this.stageName = getFieldValue(data,STAGE_FIELD);
            this.leaseType = getFieldValue(data,LEASE_TYPE_FIELD);
        }else if(error){
            console.error('Error loading Opp (wiredOpportunity)', error);
        }
    }

    get isStageNew(){
        return this.stageName === 'New';
    }

    get isOffice(){
        return this.leaseType == 'Office';
    }

    get isRetail(){
        return this.leaseType == 'Retail';
    }

    get isLand(){
        return this.leaseType == 'Land';
    }

    handleDurationChange(event){
        const durationValue = event.target.value;
        if(durationValue ==='49 years' || durationValue === '60 years'){
            this.showFileUploade = true;
        }
        else {
            this.showFileUploade = false;
        }
    }

    handleSuccess(){
        alert('Quote created successfully');
    }

    get isUploadDisabled() {
    return this.isUploading || !this.fileData;
  }

  handleFileChange(event) {
    const file = event.target.files[0];
    if (!file) {
      this.fileData = undefined;
      this.filePreviewUrl = undefined;
      return;
    }
    this.fileName = file.name;

    const reader = new FileReader();
    reader.onload = () => {
      // full data URI: "data:image/png;base64,iVBORw0KGgoAAAANS..."
      this.fileData = reader.result;
      this.filePreviewUrl = reader.result; // this drives the <img> src
    };
   reader.onerror = (err) => {
      this.status = 'Error reading file: ' + err;
    };
    reader.readAsDataURL(file);
  }

    uploadFile() {
  // 1) Ensure recordId is present
  if (!this.recordId) {
    this.status = 'Error: No record context. Please add this component to a record page.';
    return;
  }
  if (!this.fileData) {
    this.status = 'Please choose a file first.';
    return;
  }

  this.isUploading = true;
  this.status = 'Uploading...';

  uploadFileApex({
    parentId   : this.recordId,
    base64Data : this.fileData,
    fileName   : this.fileName
  })
  .then((newVersionId) => {
    this.status = 'Upload successful! Version Id: ' + newVersionId;
  })
  .catch((error) => {
    console.error('Upload failed:', error);
    // Extract human message...
    let msg = (error.body?.pageErrors?.[0]?.message)
               || error.body?.message
               || error.message
               || 'Unknown error';
    this.status = 'Upload failed: ' + msg;
  })
  .finally(() => {
    this.isUploading = false;
  });
}
}