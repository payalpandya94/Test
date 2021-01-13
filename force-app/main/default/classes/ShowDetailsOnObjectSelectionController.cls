public with sharing class ShowDetailsOnObjectSelectionController {
    @AuraEnabled
    public static List<String> getObjectList(){ //method to get list of all objects
        try{
            List<String> objectList = new List<String>();
            
            List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  //getting List of objects from Salesforce
            for(SObjectType sot:gd){
                objectList.add(sot.getDescribe().getName()); //getting labels of objects
                objectList.sort();  
            }
            
            if(objectList.size() > 0){
                return objectList;
            }
            return null;
        }
        catch(exception e){
            system.debug('error'+e.getCause() + e.getLineNumber() +e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static Map<String,string> getAllRelatedFieldList(String selectedObjectAPI){ //method to get all related fields for selected object
        try{
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType objectSchema = schemaMap.get(selectedObjectAPI);
            Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
            
            Map<String,string> relatedFields = new  Map<String,string> ();
            
            for (String fieldName: fieldMap.keySet()) {
                
                System.debug('##Field API Name='+fieldName);// list of all field API name
                relatedFields.put(fieldMap.get(fieldName).getDescribe().getLabel(),String.valueOf(fieldMap.get(fieldName).getDescribe().getType()));//It provides to get the object fields label and its type and storing it in map.
            }
            if(relatedFields.size() > 0){
                return relatedFields;
            }
            return null;
        }
        catch(exception e){
            system.debug('error'+e.getCause() + e.getLineNumber() +e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static DynamicBindingWrapper getDefaultFieldsRecord(String objectName, List<String> fieldList){ //method to get records for selected fields of selected object
        
        try{
            DynamicBindingWrapper dynamicData = new DynamicBindingWrapper();
            List<fieldDataWrapper> wrapperList =  new List<fieldDataWrapper>();
            
            String strQuery = '';
            String strFieldToQuery = '';
            
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType objectSchema = schemaMap.get(objectName);
            Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
            
            List<string> fieldListWithAPI = new  List<string> ();
            
            if(fieldList != null){
                for(String strField:fieldMap.keySet())
                {
                    for (String fieldName: fieldList) {
                        SObjectField fl = fieldMap.get(strField); //field based on API name
                        if(fieldName == fl.getDescribe().getlabel()) //comparing label
                        {
                            System.debug('##Field API Name='+strField);// list of all field API name
                            fieldListWithAPI.add(strField);//It provides to get the object fields API.
                            
                            fieldDataWrapper wrapper = new fieldDataWrapper();
                            wrapper.label = fieldMap.get(strField).getDescribe().getLabel();
                            wrapper.apiName = fieldMap.get(strField).getDescribe().getName();
                            wrapperList.add(wrapper); //storing value in wrapper
                        }
                    }
                }
            }
            else{
                return null;
            }
            //Storing Field's with API names in one string with , for fetching all fields details from SOQL
            Integer j = 0;
            String fieldsToFetch = '';
            
            if( fieldListWithAPI.size() > 0){ 
                for(String temp:fieldListWithAPI){       
                    Integer len = fieldListWithAPI.size();
                    if(j==len-1){
                        fieldsToFetch = fieldsToFetch + temp;
                    }
                    else{
                        fieldsToFetch = fieldsToFetch + temp + ',';
                    }
                    j++;
                }
            }
            if( fieldsToFetch!=null){            
                
                strQuery = 'Select ' + fieldsToFetch + ' FROM '+ objectName;
            }
            
            System.debug('strQuery'+strQuery);
            
            List<sObject> listOfFieldRecords = Database.query(strQuery);
            System.debug('listOfFieldRecords'+listOfFieldRecords);
            
            if(listOfFieldRecords!=null && listOfFieldRecords.size()>0){
                dynamicData.sObjectData = listOfFieldRecords;
            }
            else{
                dynamicData.sObjectData = new List<sObject>();
            }
            dynamicData.fieldList = wrapperList;
            System.debug('dynamicData.sObjectData--->' + dynamicData.sObjectData);
            System.debug('dynamicData.fieldList--->' + dynamicData.fieldList);
            System.debug('dynamicData--->' + dynamicData);
            return dynamicData;
        }
        catch(exception e){
            system.debug('error'+e.getCause() + e.getLineNumber() +e.getMessage());
            return null;
        }
    }
    
    //Class to store the dynamic data and list of related fields
    public class DynamicBindingWrapper{
        @AuraEnabled
        public List<sObject> sObjectData {get; set;}
        @AuraEnabled
        public List<fieldDataWrapper> fieldList {get; set;}
    }
    
    //Class to store the field information
    public class fieldDataWrapper{
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String apiName {get; set;}
    }
}