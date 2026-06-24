import { LightningElement, api } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class EmployeeManager extends LightningElement {
    empName = '';
    empAge = '';
    empEmail = '';

    employees = [];
    
    idCounter = 0;


    handleInputChange(event) {
        const fieldName = event.target.name;
        const fieldValue = event.target.value;

        if (fieldName === 'empName') {
            this.empName = fieldValue;
        } else if (fieldName === 'empAge') {
            this.empAge = fieldValue;
        } else if (fieldName === 'empEmail') {
            this.empEmail = fieldValue;
        }
    }

    handleAddEmployee() {
        if (this.empName && this.empAge && this.empEmail) {
            this.idCounter++;

            const newEmployee = {
                id: this.idCounter,
                name: this.empName,
                age: this.empAge,
                email: this.empEmail
            };

            this.employees = [...this.employees, newEmployee];
            this.empName = '';
            this.empAge = '';
            this.empEmail = '';
        }
    }

    handleDelete() {
        deleteRecord(this.recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted successfully',
                        variant: 'success'
                    })
                );
                
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
   
}