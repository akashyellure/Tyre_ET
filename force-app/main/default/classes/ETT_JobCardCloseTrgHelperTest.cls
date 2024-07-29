@isTest
public class ETT_JobCardCloseTrgHelperTest {
    private static testmethod void jobcardClose(){
         List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Organization');
        accountsList[0].Party_Type__c = 'Customer';
        insert accountsList;
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        
        
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(accountsList[0].Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
          
        ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
        ic.ETT_Tyre_Serial_Number__c = '89383';
        ic.ETT_Collection_Card__c=collectionCardsList[0].Id;
        ic.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Internal').getRecordTypeId();
        insert ic;
        
        ETT_Job_Card__c jb = new ETT_Job_Card__c();
        jb.Job_Card_Status__c ='In Progress';
        jb.ETT_Inspection_Card__c = ic.Id;
        insert jb;
        
        ETT_Job_Card_Close__c jc = new ETT_Job_Card_Close__c();
        jc.Status__c = 'New';
        jc.Job_Card__c=jb.Id;  
       
        jc.Collection_Card__c = collectionCardsList[0].id;
        insert jc;
       
        
         ETT_Tools_Master__c  tool = new ETT_Tools_Master__c();
        tool.Name='Test';
        tool.ETT_Allocated_Units__c=10;
        
        insert tool;
        
        ETT_Job_Card_Close_Lines__c jcl = new ETT_Job_Card_Close_Lines__c();
        jcl.Available_Quantity__c =23;
        jcl.Item_Name__c =tool.Id;
        jcl.Issued_Quantity__c=2;
        jcl.Unit_Cost__c=30;
        jcl.Job_Card_Close__c=jc.Id;
        insert jcl;
        
        jc.Status__c = 'Approved';
        update jc;
        
        Test.startTest();
        ETT_JobCardCloseTrgHelper.createJCCLinesInOracle(jc.Id, System.now(), jc.Name);
        Test.stopTest();
        
        //WorkOrderLineItem wol  = new WorkOrderLineItem();
        
      
    }
    
 
}