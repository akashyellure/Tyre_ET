@isTest
public class ETT_JobCardCloseCtrlTest {
    
    public static testmethod void jobcardClose(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Tyre Customer');
        insert accountsList;
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(accountsList[0].Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
          
        ETT_Job_Card__c jb = new ETT_Job_Card__c();
        jb.Job_Card_Status__c ='In Progress';
        insert jb;
        
        ETT_Job_Card_Close__c jc = new ETT_Job_Card_Close__c();
        jc.Status__c = 'New';
        jc.Job_Card__c=jb.Id;        
        insert jc;
        
        ETT_Job_Card_Close_Lines__c jcl = new ETT_Job_Card_Close_Lines__c();
        jcl.Available_Quantity__c =23;
        jcl.Job_Card_Close__c=jc.Id;
        insert jcl;
        
        List<ETT_Inspection_Card__c> inspectionList = new List<ETT_Inspection_Card__c>();
        ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
        ic.ETT_Tyre_Serial_Number__c = '89383';
        ic.ETT_Collection_Card__c=collectionCardsList[0].Id;
        inspectionList.add(ic);
        insert inspectionList;
        
        WorkOrderLineItem wol  = new WorkOrderLineItem();
       
        
        ETT_Tools_Master__c  tool = new ETT_Tools_Master__c();
        tool.Name='Test';
        
        insert tool;
        
        ETT_Job_Card_Line_Item__c  jobCardLI = new ETT_Job_Card_Line_Item__c();
        jobCardLI.ETT_Job_Card__c = jb.id; 
        jobCardLI.ETT_Activity_Performed__c = 'Check Tube Flap and Envelop';
        jobCardLI.ETT_Type__c = 'Pause';
        jobCardLI.Sequence__c = 2;
        insert jobCardLI;
               
        ETT_JobCardCloseCtrl.getJobCardRealtedDetails(jb.Id);
        ETT_JobCardCloseCtrl.getselectOptions('ETT_Job_Card_Close_Lines__c','Job_Type__c');
        ETT_JobCardCloseCtrl.getBuffingInfo(jb.id);
        ETT_JobCardCloseCtrl.createJCcloseLinesUnderJC(new list<ETT_Job_Card_Close_Lines__c>{new ETT_Job_Card_Close_Lines__c()},jc.Id);
        ETT_JobCardCloseCtrl.getAllUsedItems(jb.Id);
        ETT_JobCardCloseCtrl.getToolMasterInfo(tool.Id);
        ETT_JobCardCloseCtrl.getCuringInfo(jb.Id);
        ETT_JobCardCloseCtrl.getEnvelopeInfo(jb.Id);
        //ETT_JobCardCloseCtrl.getJobTypeValue(inspectionList[0].id);
    }

}