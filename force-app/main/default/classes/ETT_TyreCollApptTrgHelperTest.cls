@isTest
public class ETT_TyreCollApptTrgHelperTest {
    
    public static testmethod void createCollCard(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Tyre Customer');
        insert accountsList;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        Vehicle_Master__c ev = new Vehicle_Master__c();
        ev.Name='B002344';
        ev.Internal_No__c='B002344';
        insert ev;
        
        Tyre_Collection_Appointment__c tcp = new Tyre_Collection_Appointment__c();
        tcp.Account__c = accountsList[0].Id;
        tcp.Actual_Start__c = system.now();
        tcp.Scheduled_Start__c =system.now()+5;
        //tcp.Driver__c = userinfo.getUserId();
        tcp.Location__c = 'Test';
        tcp.Status__c ='New';
        tcp.Appointment_Type__c ='Collection';
        tcp.Opportunity__c = opp.id;
        //tcp.Vehicle__c = ev.id;
        tcp.RecordTypeId =  Schema.SObjectType.Tyre_Collection_Appointment__c.getRecordTypeInfosByName().get('Tyre - Internal Private').getRecordTypeId();
        insert tcp;
        
        tcp.Status__c ='Approved';
        update tcp;
        
        List<ETT_Collection_Card__c> collectionCardList = new List<ETT_Collection_Card__c>();
        ETT_Collection_Card__c collectionCard = new ETT_Collection_Card__c();
        collectionCard.ETT_Opportunity__c = opp.id;
        collectionCard.Collection_Appointment__c = tcp.id;
        collectionCard.ETT_Collection_Status__c = 'Scheduled';
        collectionCard.ETT_Accounts__c = accountsList[0].Id;
        collectionCardList.add(collectionCard);
        insert collectionCardList;
        
    }
    
    public static testmethod void createCollCard1(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Tyre Customer');
        insert accountsList;
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Refurbishing Services','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        Vehicle_Master__c ev = new Vehicle_Master__c();
        ev.Name='B002344';
        ev.Internal_No__c='B002344';
        insert ev;
        
        Tyre_Collection_Appointment__c tcp = new Tyre_Collection_Appointment__c();
        tcp.Account__c = accountsList[0].Id;
        tcp.Actual_Start__c = system.now();
        tcp.Scheduled_Start__c =system.now()+5;
        //tcp.Driver__c = userinfo.getUserId();
        tcp.Location__c = 'Test';
        tcp.Status__c ='New';
        tcp.Appointment_Type__c ='Collection';
        tcp.Opportunity__c = opp.id;
        //tcp.Vehicle__c = ev.id;
        tcp.RecordTypeId =  Schema.SObjectType.Tyre_Collection_Appointment__c.getRecordTypeInfosByName().get('Tyre - Internal Private').getRecordTypeId();
        insert tcp;
        
        tcp.Status__c ='Approved';
        update tcp;
        
        List<ETT_Collection_Card__c> collectionCardList = new List<ETT_Collection_Card__c>();
        ETT_Collection_Card__c collectionCard = new ETT_Collection_Card__c();
        collectionCard.ETT_Opportunity__c = opp.id;
        collectionCard.Collection_Appointment__c = tcp.id;
        collectionCard.ETT_Collection_Status__c = 'Scheduled';
        collectionCard.ETT_Accounts__c = accountsList[0].Id;
        collectionCardList.add(collectionCard);
        insert collectionCardList;
        
    }
    
    
}