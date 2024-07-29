@isTest
public class ETT_ServiceAppointmentTrigHandler_Test {

    @isTest(SeeAllData=false)
    static  void Controller_TestClass1(){
        
        List<ServiceAppointment> lstSA = new List<ServiceAppointment>();
        Map<Id,ServiceAppointment> oldMap = new  Map<Id,ServiceAppointment>();
        
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1; //insert account
        
        
        WorkOrder WO = new WorkOrder ();
        WO.AccountId = objAcc1.Id;
        WO.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('ETT_Tyre_Cash_Supplier').getRecordTypeId();
        insert WO;
        
        OperatingHours objOH = new OperatingHours();
        objOH.Name = 'TestOH';
        insert objOH; 
        
        ServiceTerritory objST = new ServiceTerritory();
        objST.Name = 'Test Territory';
        objST.OperatingHoursId = objOH.Id;
        objST.IsActive = TRUE;
        insert objST;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'staett', Email='standarduserforETT@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserett@testorg.com');
        insert u;
        
        ServiceResource objServiceResource=new ServiceResource();
        objServiceResource.Name='Test Resource';
        objServiceResource.RelatedRecordId=u.Id;
        objServiceResource.ResourceType='T';
        objServiceResource.IsActive=True;
        //objServiceResource.Status_Code__c='SB';
        insert objServiceResource;       
        
        ServiceTerritoryMember objSTM = new ServiceTerritoryMember();
        objSTM.TerritoryType = 'P';
        objSTM.ServiceTerritoryId = objST.Id;
        objSTM.ServiceResourceId = objServiceResource.Id;
        objSTM.EffectiveStartDate = Date.today().addYears(+1);
        objSTM.EffectiveEndDate = Date.today().addYears(+10);
        objSTM.OperatingHoursId = objOH.Id;
        insert objSTM;
        
        DateTime EarliestStartTime = DateTime.Now().AddDays(+3);
        DateTime DueDate = DateTime.Now().AddDays(+5);
        
        ETT_Delivery_Note__c objDN = new ETT_Delivery_Note__c();
        insert objDN;
        
        ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
        insert objIC;
        
        ETT_Delivery_Line_Item__c objDNI = new ETT_Delivery_Line_Item__c();
        objDNI.ETT_Inspection_Card__c = objIC.Id;
        insert objDNI;
        
        ETT_Tyre_Inventory__c objTI = new ETT_Tyre_Inventory__c();
        objTI.ETT_Tyre_Inspection_Card__c = objIC.Id;
            
            
        ServiceAppointment objSA = new ServiceAppointment();
        objSA.RecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByDeveloperName().get('Tyre_Return_Appointment').getRecordTypeId();
        objSA.Status = 'In Progress';
        objSA.ParentRecordId = wo.Id;
        objSA.ServiceTerritoryId = objST.Id;
        objSA.SchedStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
        datetime enddate = wo.StartDate !=null ? wo.StartDate.addDays(1) :Date.today().addDays(1);
        objSA.EarliestStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
        objSA.DueDate =  wo.StartDate !=null ? wo.StartDate.addDays(2) :Date.today().addDays(2);
        objSA.SchedEndTime = enddate;
        objSA.Duration = 0;
        objSA.DurationType = 'Minutes';
        objSA.ETT_Delivery_Note__c = objDN.Id;
        insert objSA;
        
        
        objSA.Status = 'Completed';
        update objSA;
        
        lstSA.add(objSA);
        oldMap.put(objSA.Id,objSA);
        
        
        
        ETT_ServiceAppointmentTriggerHandler.updateTyreInventoryStatus(lstSA, oldMap);
        ETT_ServiceAppointmentTriggerHandler.callCoverage();
    }
    
}