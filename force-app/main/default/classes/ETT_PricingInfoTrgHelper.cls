/**
 * Author: Janardhan Muddana
 * Desc:
 * Create Date:07/02/22
 * TestClass:ETT_PricingInfoTrgHelperTest
 * */
public class ETT_PricingInfoTrgHelper {
    
    public static void duplicationCheck(list<ETT_Pricing_Information__c> trgNew){
        
    
         set<Id> priceMasterIds = new set<id>();
         set<string> exisitingRecSet = new set<string>();
        
        for(ETT_Pricing_Information__c pi : trgNew){
             priceMasterIds.add(pi.ETT_Price__c);
        }
        
        for(ETT_Pricing_Information__c pie : [Select id,ETT_Price__c,ETT_Tyre_Size__c,ETT_Brand__c,ETT_Country_of_Origin__c,ETT_Pattern__c from ETT_Pricing_Information__c where ETT_Price__c=:priceMasterIds]){
           
            exisitingRecSet.add(pie.ETT_Price__c+''+pie.ETT_Tyre_Size__c+''+pie.ETT_Brand__c+''+pie.ETT_Country_of_Origin__c+''+pie.ETT_Pattern__c);

        }
      
        for(ETT_Pricing_Information__c pie : trgNew){
            
            string key  = pie.ETT_Price__c+''+pie.ETT_Tyre_Size__c+''+pie.ETT_Brand__c+''+pie.ETT_Country_of_Origin__c+''+pie.ETT_Pattern__c;
           
           
            if(exisitingRecSet.contains(key)){
                
                pie.Id.adderror('Duplicate Pricing Information is identified.');
            }
        }
        
    }

}