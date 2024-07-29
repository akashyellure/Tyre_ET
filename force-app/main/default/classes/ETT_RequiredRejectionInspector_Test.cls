@isTest public class ETT_RequiredRejectionInspector_Test {
    @isTest public static void CodeCoverage(){
        Account acc = new Account();
        acc.Name = 'Test account';
        insert acc;
        
        Lead lead = new Lead();
        lead.Company = 'test';
        lead.LastName = 'dubai';
                lead.Phone = '98765432';
        insert lead;
        
        ETT_Fleet_Analysis_Request__c fleetAnalysisRequest = new ETT_Fleet_Analysis_Request__c();
        fleetAnalysisRequest.ETT_Customer_Name__c = lead.Company;
        fleetAnalysisRequest.ETT_Account__c = acc.id;
        fleetAnalysisRequest.Lead__c = lead.Id;
        //fleetAnalysisRequest.Status__c = 'Rejected By HOO' ;
        //fleetAnalysisRequest.Approval_Status_Check__c = 'Requested';
        insert fleetAnalysisRequest;
        update fleetAnalysisRequest;
    }
    @isTest public static void CodeCoverage1(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];        
        
        User user1 = new User();
        user1.Username = 'stand3423@jana9334.com';
        user1.Email = 'us1@test.com';
        user1.LastName = 'LastName1';
        user1.FirstName = 'FirstName1';
        user1.Alias ='u1';
        user1.CommunityNickname ='use1';
        user1.ProfileId =p.id;
        user1.ETI_Inspection_Center__c='DXB-RL-M';
        
        user1.EmailEncodingKey='UTF-8';
        user1.LanguageLocaleKey='en_US';
        user1.LocaleSidKey='en_US';
        user1.TimeZoneSidKey='America/Los_Angeles';
        user1.Country = 'US';
        user1.Title = 'Territory Manager';
        user1.EmployeeNumber ='123456';
        insert user1;
        
        Account acc = new Account();
        acc.Name = 'Test account';
        insert acc;
        
        Lead lead = new Lead();
        lead.Company = 'test';
        lead.LastName = 'dubai';
                lead.Phone = '98765432';
        insert lead;
        
        ETT_Fleet_Analysis_Request__c fleetAnalysisRequest = new ETT_Fleet_Analysis_Request__c();
        fleetAnalysisRequest.ETT_Customer_Name__c = lead.Company;
        fleetAnalysisRequest.ETT_Account__c = acc.id;
        fleetAnalysisRequest.Lead__c = lead.Id;
        
        insert fleetAnalysisRequest;
        fleetAnalysisRequest.Status__c = 'Rejected By HOO' ;
        fleetAnalysisRequest.Approval_Status_Check__c = 'Requested';
        Test.startTest();
        update fleetAnalysisRequest;
        fleetAnalysisRequest.Status__c = 'Approved  By HOO' ;
        fleetAnalysisRequest.ETT_Inspector__c = user1.Id;
        update fleetAnalysisRequest;
        Test.stopTest();
    }
    
}