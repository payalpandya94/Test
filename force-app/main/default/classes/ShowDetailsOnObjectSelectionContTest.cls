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
        selectedFields.add('Id');
        selectedFields.add('Name');
        
        Account acc = new Account(name='Test Account');
        insert acc;
        
        Test.startTest();
        ShowDetailsOnObjectSelectionController.DynamicBindingWrapper recordDataWrapper = ShowDetailsOnObjectSelectionController.getDefaultFieldsRecord(selectedObject,selectedFields);
        Test.stopTest();
    }
}