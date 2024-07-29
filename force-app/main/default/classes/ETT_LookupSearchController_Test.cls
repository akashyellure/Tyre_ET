@isTest
public class ETT_LookupSearchController_Test {
  /*  @isTest public static void menthod1(){
        String accName = 'TestETTAcc'+Datetime.Now();
        List<Account> lstAcc = ETT_TestFactory.createAccounts(accName, 'Tyre Supplier');
        
        insert lstAcc;
        
        Contact cont = new Contact();
        cont.FirstName='Test';
        cont.LastName='Test';
        cont.Accountid= lstAcc[0].Id;
        insert cont;
        
        Opportunity objOpp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier', 'testOpp', 'Qualification', Date.today() + 180, lstAcc[0].Id);
        insert objOpp;
        
        WorkOrder objWorkOrder1 = new WorkOrder (AccountId = lstAcc[0].Id,StartDate = Datetime.Now());
        insert objWorkOrder1;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'ETT_Collection Team'].Id,
            LastName = 'last'+Datetime.Now(),
            Email = 'test@amama.com',
            Username = 'test@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
        
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'TestOH';
        insert oh;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'India';
        objServiceTerritory.OperatingHoursId = oh.Id;
        objServiceTerritory.IsActive = true;
        insert objServiceTerritory;
        
        ServiceResource objServiceResource = new ServiceResource();
        objServiceResource.Name = 'Rohan'+Datetime.Now();
        objServiceResource.ResourceType = 'T';
        objServiceResource.RelatedRecordId = u.Id;
        objServiceResource.IsActive=true;
        insert objServiceResource;
        
        ServiceTerritoryMember objSTM = new ServiceTerritoryMember();
        objSTM.TerritoryType = 'P';
        objSTM.ServiceTerritoryId = objServiceTerritory.Id;
        objSTM.ServiceResourceId = objServiceResource.Id;
        objSTM.EffectiveStartDate = Date.today().addYears(-1);
        objSTM.EffectiveEndDate = Date.today().addYears(2);
        insert objSTM;
        
        ServiceAppointment objServiceAppt = new ServiceAppointment();
        objServiceAppt.ETT_Opportunity__c = objOpp.Id;
        objServiceAppt.Status = 'None';
        //objServiceAppt.EarliestStartTime = DateTime.Now().AddDays(+2);
        objServiceAppt.EarliestStartTime = objWorkOrder1.StartDate !=null ? (objWorkOrder1.StartDate ):(Date.today());
            objServiceAppt.DueDate = DateTime.Now().AddDays(+5);
        objServiceAppt.SchedStartTime = DateTime.Now().AddDays(+4);
        objServiceAppt.SchedEndTime = DateTime.Now().AddDays(+5);
        objServiceAppt.ParentRecordId = objWorkOrder1.Id;
        objServiceAppt.ServiceTerritoryId = objServiceTerritory.Id;
        objServiceAppt.Duration = 1;
        insert objServiceAppt;
        
        ETT_Collection_Card__c coll= new ETT_Collection_Card__c();
        coll.ETT_Service_Appointment__c=objServiceAppt.Id;
        insert coll; 
        List<WorkOrderLineItem> workline = new  List<WorkOrderLineItem>();
        WorkOrderLineItem worklineitem= new WorkOrderLineItem();
        worklineitem.ETT_Tyre_Serial_Number__c='7565';
        worklineitem.ETT_Accounts__c=lstAcc[0].Id;
        worklineitem.ETT_Collection_Card__c=coll.id;
        worklineitem.ETT_Opportunity__c =objOpp.id;
        worklineitem.WorkOrderId=objWorkOrder1.id;
         workline.add(worklineitem);
        // insert worklineitem;
  			insert workline;
        
        ETT_Inspection_Card__c insp=new ETT_Inspection_Card__c();
        insp.ETT_Collection_Card__c=coll.Id;
        
        insert insp;
        
        
        ETT_Job_Card__c jobcr= new ETT_Job_Card__c();
        jobcr.ETT_Inspection_Card__c=insp.Id;
        insert jobcr;
        
        ETT_Tyre_Master__c tyre= new ETT_Tyre_Master__c();
        tyre.ETT_Collection_Card__c = coll.Id;
        insert tyre;
        System.debug('tyre details '+tyre);
        
        Case cs= new Case();
        cs.Collection_Card__c=coll.Id;
        cs.Inspection_Card__c=insp.id;
        cs.Service_Appointment__c=objServiceAppt.Id;
        insert cs;
        System.debug('cs '+cs);
        ETT_LookupSearchController.updateCase(cs.id, coll.Id, insp.Id, jobcr.Id, objServiceAppt.Id);
        ETT_LookupSearchController.ResultWrapper wrap= new ETT_LookupSearchController.ResultWrapper();
        wrap.objName='';
        wrap.collectionCard='';
        wrap.inspectionCard='';
        wrap.jobCard='';
        wrap.serviceAppointmentId='';
        wrap.serviceAppointmentNumber='';
        wrap.text='';
        wrap.val='';
        ETT_LookupSearchController.searchDB('WorkOrderLineItem', 'ETT_Tyre_Serial_Number__c','ETT_Tyre_Master__c', 1, 'ETT_Tyre_Serial_Number__c', '7565');
        
    }  
       */ 
         @isTest public static void  testmethod1(){
        Test.startTest();
        ETT_LookupSearchController.utilityMethod();
        Test.stopTest();
    }
        /* 
Account acc= new Account();
acc.Name='TEST';
insert acc;
System.debug('acc '+acc);

ServiceAppointment serapp= new ServiceAppointment();
serapp.ETT_Account__c=acc.Id;
insert  serapp;   

ETT_Collection_Card__c coll= new ETT_Collection_Card__c();
coll.ETT_Service_Appointment__c=serapp.Id;
insert coll; 

ETT_Inspection_Card__c insp=new ETT_Inspection_Card__c();
insp.ETT_Account__c=acc.id;
insert insp;


ETT_Job_Card__c jobcr= new ETT_Job_Card__c();
jobcr.ETT_Inspection_Card__c=insp.Id;
insert jobcr;

ETT_Tyre_Master__c tyre= new ETT_Tyre_Master__c();
tyre.ETT_Collection_Card__c = coll.Id;
insert tyre;

Case cs= new Case();
cs.AccountId=acc.Id;
cs.Inspection_Card__c=insp.id;
cs.Service_Appointment__c=serapp.Id;
insert cs;
System.debug('cs '+cs);
ETT_LookupSearchController.updateCase(cs.id, coll.Id, insp.Id, jobcr.Id, serapp.Id);
ETT_LookupSearchController.searchDB('ETT_Collection_Card__c', '','Tyre_Serial_Number__c', 1, 'Tyre_Serial_Number__c', tyre.Id);
*/
        
   
}