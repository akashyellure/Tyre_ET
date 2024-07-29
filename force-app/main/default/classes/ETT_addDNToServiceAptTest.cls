@isTest
public class ETT_addDNToServiceAptTest {
    
    private static testmethod void dntest(){
     List<Account> accountsList = ETT_TestFactory.createAccounts('Test92J35464', 'Organization');
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
        tcp.Scheduled_Start__c =system.now();
        tcp.Driver__c = userinfo.getUserId();
        tcp.Location__c = 'Test';
        tcp.Status__c ='New';
        tcp.Opportunity__c = opp.id;
        tcp.Vehicle__c = ev.id;
        insert tcp;
    
    ETT_Delivery_Note__c dn = new ETT_Delivery_Note__c();
    dn.ETT_Account__c = accountsList[0].id;
    dn.DN_Status__c ='Approved';
    insert dn;
    
    ETT_addDNToServiceApt.getDNDetails(tcp.id);    
    ETT_addDNToServiceApt.updateDNDetails(new list<ETT_Delivery_Note__c>{dn});
    
    }
}