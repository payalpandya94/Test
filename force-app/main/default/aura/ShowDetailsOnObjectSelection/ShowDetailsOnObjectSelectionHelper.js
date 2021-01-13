({
    getObjectListHelper : function(component, event, helper) {
        
        //function to get list of all objects
        //
        var action = component.get("c.getObjectList");//Apex method to get list of Object
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {           
                var allValues = response.getReturnValue();
                component.set("v.listOfObjects", allValues);
            }                    
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getFieldListHelper : function(component, event, helper) {
        
        //function to get all related fields for selected object
        
        var selectedObject = component.get("v.selectedValue");
        
        var action = component.get("c.getAllRelatedFieldList");//Apex method to get list of Object
        
        //passing paramaters
        action.setParams({
            selectedObjectAPI : selectedObject
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                var fieldsList = [];
                var result = response.getReturnValue();
                if(result != null){
                    for ( var key in result ) {
                        fieldsList.push({value:result[key], key:key});
                    }
                }
                component.set("v.listOfFields", fieldsList);
            }                    
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getFieldsRecordsTable:function(component, event){
        
        //function to get records for selected fields of selected object
        
        var objectName = component.get("v.selectedValue"); 
        var selectedFields = component.get("v.selectedFieldValues");
        
        var action = component.get("c.getDefaultFieldsRecord");   
        
        action.setParams({
            "objectName": objectName,
            "fieldList": selectedFields
        });
        
        action.setCallback(this,function(response){            
            var state  = response.getState(); 
            
            if(state == "SUCCESS"){
                
                var allValues = response.getReturnValue();
                
                if(allValues != null){
                    
                    console.log('allValues--->' + allValues);
                    var objectValue = allValues.sObjectData;
                    console.log('objectValue--->' + objectValue);
                    var fieldList = allValues.fieldList;
                    console.log('fieldList--->' + fieldList);
                    
                    /* Create Dynamic Table */
                    var sObjectDataTableHeader = [];
                    // Create table Header
                    for (var i=0; i<fieldList.length; i++) {
                        sObjectDataTableHeader.push(fieldList[i].label);
                    }
                    console.log('sObjectDataTableHeader--->>' + sObjectDataTableHeader);
                    //Get the count of columns.
                    var columnCount = sObjectDataTableHeader.length;
                    //Create a HTML Table element.
                    var table = document.createElement("TABLE");
                    //table.border='2';
                    //Add the header row.
                    var row = table.insertRow(-1);
                    for (var i=0; i<columnCount; i++) {
                        var headerCell = document.createElement("TH");
                        //headerCell.width='75';
                        headerCell.innerHTML = sObjectDataTableHeader[i];
                        headerCell.className='headerClass';
                        row.appendChild(headerCell);
                    }
                    var dvTable = document.getElementById("sfdctable");
                    dvTable.innerHTML = "";
                    dvTable.appendChild(table);
                    
                    /* Create Dynamic Table End */    
                    if(objectValue.length){
                        for(var j=0; j<objectValue.length; j++){
                            // Dynamic table Row
                            row = table.insertRow(-1);
                            // Dynamic Table Row End
                            for (var i=0; i<fieldList.length; i++) {
                                // Dynamic table Row
                                var cell = row.insertCell(-1);
                                cell.innerHTML = objectValue[j][fieldList[i].apiName]; 
                            }
                        }
                    }
                }
            }
            else{               
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message final: " + 
                                    errors[0].message);
                    }
                } 
                console.log("Failed with state: " + state);
            }
        });        
        $A.enqueueAction(action);       
    }
})