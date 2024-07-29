@isTest
public class ETT_MaterialReturnNoteTriggerHandlerTest {
 @isTest public static void OracleHelper(){
    ETT_Material_Return_Note__c VarM = New ETT_Material_Return_Note__c();
     VarM.Status__c = 'Approved';
     insert VarM;
     ETT_MaterialReturnNoteTriggerHandler.createMRInOracle (VarM.id,VarM.CreatedDate,VarM.Name);
Test.startTest();
     ETT_MaterialReturnNoteTriggerHandler.createMRInOracle (VarM.id,VarM.CreatedDate,VarM.Name);
     Material_Return_Lines__c mLine = New Material_Return_Lines__c ();
     //mLine.Item_Code__c = 'CN-OMNI-CT-20';
      mLine.Return_Qty__c = 3;
        mLine.Average_Rate__c = Null;
     mLine.Material_Return_Note__c = VarM.id;
     insert mLine;
     
Test.stopTest();
}
   
}