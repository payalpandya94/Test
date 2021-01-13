({
    doinit : function(component, event, helper) {
        //to get values in dropdown of All Objects
        helper.getObjectListHelper(component, event, helper);
    },
    handleClick  : function(component, event, helper) {
        //to get all fields related to selected Object in dropdown
        helper.getFieldListHelper(component, event, helper);
        component.set("v.showSelectedObjFields",true);//setting up visibility of section of showing related Fields of selected object
    },
    checkboxSelect : function(component, event, helper) {
        //to get selected value of field
        var selectedFields = [];
        var checkvalue = component.find("checkFields");
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedFields.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedFields.push(checkvalue[i].get("v.text"));
                }
            }
        }     
        var objectName = component.get("v.selectedValue"); 
        component.set("v.selectedFieldValues",selectedFields); //storing all selected fields     
    },
    
    showRecords : function(component, event, helper) {
        helper.getFieldsRecordsTable(component,event); //to get records for selected fields and object
        component.set("v.showDataOfSelectedFields",true); //setting up visibility of section of showing record data
    },
})