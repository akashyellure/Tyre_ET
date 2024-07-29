@isTest
public class ETT_TyreWorkStationHomeCtrlTest {
    
    private static testmethod void tyreWorkStation(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Tyre Customer');
        insert accountsList;
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(accountsList[0].Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
        
        ETT_Job_Card__c jb = new ETT_Job_Card__c();
        jb.Job_Card_Status__c ='In Progress';
        jb.ETT_Stages__c ='Buffing';
        insert jb;
        
        ETT_Work_Station__c ws = new ETT_Work_Station__c();
        ws.ETT_Station_Type__c = 'Buffing';
        ws.ETT_Station_Code__c ='001';
        insert ws;
        
        ETT_Work_Schedule__c wsch = new ETT_Work_Schedule__c();
        wsch.ETT_Work_Station__c = ws.Id;
        wsch.ETT_Start_time__c = system.now();
        wsch.ETT_End_time__c = system.now()+1;
        wsch.ETT_Technician__c = userinfo.getUserId();
        insert wsch;
        
        ETT_Work_Station_Checklist__c wsc = new ETT_Work_Station_Checklist__c();
        wsc.Work_Schedule__c = wsch.Id;
        wsc.Work_Station__c = ws.Id;
        
        
        ETT_TyreWorkStationHomeCtrl.getUserDetails();
        ETT_TyreWorkStationHomeCtrl.getWorkscheduleInfo();
        ETT_TyreWorkStationHomeCtrl.getJobCardsInfo();
        ETT_TyreWorkStationHomeCtrl.createWorkStationCheckList(wsc);
        ETT_TyreWorkStationHomeCtrl.getWorkStatCheckListDetails();
    }
   private static testmethod void tyreWorkStation2(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Tyre Customer');
        insert accountsList;
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(accountsList[0].Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
        
        ETT_Job_Card__c jb = new ETT_Job_Card__c();
        jb.Job_Card_Status__c ='In Progress';
        jb.ETT_Stages__c ='Thread Preparation';
        insert jb;
       
       ETT_Job_Card__c jb1 = new ETT_Job_Card__c();
       jb1.Job_Card_Status__c ='In Progress';
       jb1.ETT_Stages__c ='Thread Preparation';
       jb1.ETT_Main_Job_Card__c =jb.id;
       insert jb1;
        
        ETT_Work_Station__c ws = new ETT_Work_Station__c();
        ws.ETT_Station_Type__c = 'Thread Preparation';
        ws.ETT_Station_Code__c ='001';
        insert ws;
        
        ETT_Work_Schedule__c wsch = new ETT_Work_Schedule__c();
        wsch.ETT_Work_Station__c = ws.Id;
        wsch.ETT_Start_time__c = system.now();
        wsch.ETT_End_time__c = system.now()+1;
        wsch.ETT_Technician__c = userinfo.getUserId();
        insert wsch;
            
      
        ETT_TyreWorkStationHomeCtrl.getJobCardsInfo();
       
    }

}