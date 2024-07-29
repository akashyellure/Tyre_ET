@isTest
public class ETT_TyreInspectionCard_test {
    
    @isTest static void testMethod1(){
        List < ETT_Inspection_Card__c> cardList =[ SELECT Id, Name, ETT_Collection_Card__r.Name, ETT_Tyre_Size__r.Name, ETT_Priority__c,
                                                  ETT_Brand__r.Name,ETT_Pattern__r.Name,ETT_Country__r.Name,ETT_Status__c FROM ETT_Inspection_Card__c where ETT_Status__c='Not Inspected' order by Name asc];
        
        //new List<ETT_Inspection_Card__c>();      
        
        List <ETT_Inspection_Card__c> stList = ETT_TyreInspectionCard.getInspetionCardDetails();
        List<ETT_Inspection_Card__c> utList=new List <ETT_Inspection_Card__c>(cardList) ;
        //utList.add('ytt');
        ETT_TyreInspectionCard.updateInspectionCardPriority(utList);
        update stList;
        
        ETT_TyreInspectionCard.getselectOptions('ETT_Tyre_Life__c');
        
        ETT_Country_Master__c objCountry = ETT_TestFactory.createCountries('Japan');
        List<ETT_Pattern_Master__c> lstPatternMaster = ETT_TestFactory.createPatternMasters();
        List<ETT_Tyre_Size_Master__c> lstTyreSizeMaster = ETT_TestFactory.createTyreSizeMaster();
        List<ETT_Brand_Master__c> lstBrandMaster = ETT_TestFactory.createBrandMasters();
        
        List<Account> acc = ETT_TestFactory.createAccounts('testAcc', 'Tyre Supplier');
        Opportunity objOpp = ETT_TestFactory.createOpportunity('Tyre - Cash Supplier', 'testOpp', 'Qualification', Date.today() + 180, acc[0].Id);
       
        List<ETT_Collection_Card__c> lstCC = ETT_TestFactory.createCollectionCards(acc[0].Id, objOpp.Id);
        
        List<ETT_Inspection_Card__c> lstIC = ETT_TestFactory.createInspectionCards('Tyre - Cash Supplier', acc[0].Id, lstBrandMaster[0].Id, lstCC[0].Id, lstTyreSizeMaster[0].Id);
        insert lstIC;
        
        ETT_TyreInspectionCard.updateInspectionCardPriority(lstIC);
        
    }
    
}