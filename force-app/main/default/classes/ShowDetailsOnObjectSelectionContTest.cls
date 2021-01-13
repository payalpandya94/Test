@isTest
public class ShowDetailsOnObjectSelectionContTest {
    @isTest
    public Static void checkObjectListMethod(){
        Test.startTest();
        List<String> objectListValue = ShowDetailsOnObjectSelectionController.getObjectList();
        system.assert(objectListValue != null);
        Test.stopTest();
    }
    @isTest
    public Static void checkAllRelatedFieldListMethod(){
        String selectedObject = 'Account';
        Test.startTest();
        Map<String,string> AllRelatedFieldListValue= ShowDetailsOnObjectSelectionController.getAllRelatedFieldList(selectedObject);
        system.assert(AllRelatedFieldListValue != null);
        Test.stopTest();
    }
    @isTest
    public Static void checkDefaultFieldsRecordMethod(){
        String selectedObject = 'Account';
        List<String> selectedFields = new List<String>();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType objectSchema = schemaMap.get(selectedObject);
            Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
            
            Map<String,string> relatedFields = new  Map<String,string> ();
            
            for (String fieldName: fieldMap.keySet()) {
                
                System.debug('##Field API Name='+fieldName);// list of all field API name
                selectedFields.add(fieldMap.get(fieldName).getDescribe().getLabel());//It provides to get the object fields label.
            }
        
        Account acc = new Account(name='Test Account');
        insert acc;
        
        Test.startTest();
        ShowDetailsOnObjectSelectionController.DynamicBindingWrapper recordDataWrapper = ShowDetailsOnObjectSelectionController.getDefaultFieldsRecord(selectedObject,selectedFields);
        Test.stopTest();
    }
}