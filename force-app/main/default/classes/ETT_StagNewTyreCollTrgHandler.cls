/**
* Author:Janardhan
* Date:29/11/2021
* 
* */
public class ETT_StagNewTyreCollTrgHandler {
    
    public static void createPricingInfoAndOthers(list<ETT_StagingNewTyreCollection__c> trgNew){
        Map<id,boolean> collCCIdVshasNewTyrewoPrice = new map<id,boolean>();
        list<ETT_Tyre_Master__c> insertNewTyreMasterList = new  list<ETT_Tyre_Master__c>();
        list<ETT_Collection_Card__c> ccUpdateList = new list<ETT_Collection_Card__c>();
        map<string,ETT_StagingNewTyreCollection__c> keyVsStagNewTyre = new map<string,ETT_StagingNewTyreCollection__c>();
        
        /**** Start Tyre Size logic--Check Tyre size master has tyre size, if not create new one in tyre size master ****/
        set<string> newTyreSize = new set<string>();
        map<string,Id> tyreSizeVsId =  new map<string,id>();
        list<ETT_Tyre_Size_Master__c> newTyreSizelist = new  list<ETT_Tyre_Size_Master__c>();
        
        for(ETT_StagingNewTyreCollection__c newTyre : trgNew){
            
            newTyreSize.add(newTyre.Size_Name__c);
            
        }            
        for(ETT_Tyre_Size_Master__c ts: [select id,name from ETT_Tyre_Size_Master__c where Name=:newTyreSize]){
            
            tyreSizeVsId.put(ts.Name,ts.Id);
        }
        
        for(string str : newTyreSize){
            
            if(!tyreSizeVsId.containsKey(str)){
                ETT_Tyre_Size_Master__c ts = new ETT_Tyre_Size_Master__c();
                ts.Name = str;
                newTyreSizelist.add(ts);
            }
            
        }
        
        insert newTyreSizelist;
        
        for(ETT_Tyre_Size_Master__c ts: [select id,name from ETT_Tyre_Size_Master__c where Name=:newTyreSize]){
            
            tyreSizeVsId.put(ts.Name,ts.Id);
        }
        /**** End Tyre Size logic ****/
        /**** Start Brand logic ****/
        set<string> newBrand = new set<string>();
        map<string,Id> brandVsId =  new map<string,id>();
        list<ETT_Brand_Master__c> newBrandlist = new  list<ETT_Brand_Master__c>();
        
        for(ETT_StagingNewTyreCollection__c newTyre : trgNew){
            
            newBrand.add(newTyre.Brand_Name__c);
            
        }            
        for(ETT_Brand_Master__c br: [select id,Name from ETT_Brand_Master__c where Name=:newBrand]){
            
            brandVsId.put(br.Name,br.Id);
        }
        
        for(string str : newBrand){
            
            if(!brandVsId.containsKey(str)){
                ETT_Brand_Master__c bm = new ETT_Brand_Master__c();
                bm.Name = str;
                newBrandlist.add(bm);
            }
            
        }
        
        insert newBrandlist;
        
        for(ETT_Brand_Master__c bm: [select id,name from ETT_Brand_Master__c where Name=:newBrand]){
            
            brandVsId.put(bm.Name,bm.Id);
        }
        /**** End Brand logic ****/
        /**** Start Pattern logic ****/
        set<string> newPattern = new set<string>();
        map<string,Id> patternVsId =  new map<string,id>();
        list<ETT_Pattern_Master__c> newPatternlist = new  list<ETT_Pattern_Master__c>();
        
        for(ETT_StagingNewTyreCollection__c newTyre : trgNew){
            
            newPattern.add(newTyre.Pattern_Name__c);
            
        }            
        for(ETT_Pattern_Master__c pr: [select id,Name from ETT_Pattern_Master__c where Name=:newPattern]){
            
            patternVsId.put(pr.Name,pr.Id);
        }
        
        for(string str : newPattern){
            
            if(!patternVsId.containsKey(str)){
                ETT_Pattern_Master__c pm = new ETT_Pattern_Master__c();
                pm.Name = str;
                newPatternlist.add(pm);
            }
            
        }
        
        insert newPatternlist;
        
        for(ETT_Pattern_Master__c bm: [select id,name from ETT_Pattern_Master__c where Name=:newPattern]){
            
            patternVsId.put(bm.Name,bm.Id);
        }
        /**** End pattern logic ****/       
        
        /**** Start country logic ****/
        set<string> newCountry = new set<string>();
        map<string,Id> countryVsId =  new map<string,id>();
        list<ETT_Country_Master__c> newCountrylist = new  list<ETT_Country_Master__c>();
        
        for(ETT_StagingNewTyreCollection__c newTyre : trgNew){
            
            newCountry.add(newTyre.Country_Name__c);
            
        }            
        for(ETT_Country_Master__c cm: [select id,Name from ETT_Country_Master__c where Name=:newCountry]){
            
            countryVsId.put(cm.Name,cm.Id);
        }
        
        for(string str : newCountry){
            
            if(!countryVsId.containsKey(str)){
                ETT_Country_Master__c pm = new ETT_Country_Master__c();
                pm.Name = str;
                newCountrylist.add(pm);
            }
            
        }
        
        insert newCountrylist;
        
        for(ETT_Country_Master__c bm: [select id,name from ETT_Country_Master__c where Name=:newCountry]){
            
            countryVsId.put(bm.Name,bm.Id);
        }
        /**** End country logic ****/
        //Create New Tyre Master with above details in draft mode
        
        
        for(ETT_StagingNewTyreCollection__c newTyre : trgNew){
            
            collCCIdVshasNewTyrewoPrice.put(newTyre.Collection_Card__c,true); 
            string key = newTyre.Size_Name__c+'-'+newTyre.Brand_Name__c+'-'+newTyre.Country_Name__c+'-'+newTyre.Pattern_Name__c;
            keyVsStagNewTyre.put(key,newTyre);
          
            //update Staging Table
           newTyre.Brand__c = brandVsId.get(newTyre.Brand_Name__c);
           newTyre.Tyre_Size__c = tyreSizeVsId.get(newTyre.Size_Name__c);
           newTyre.Pattern__c =patternVsId.get(newTyre.Pattern_Name__c);
           newTyre.Country__c =countryVsId.get(newTyre.Country_Name__c);
            
          
        }
        for(string str : keyVsStagNewTyre.keyset()){
            
            ETT_Tyre_Master__c tm = new ETT_Tyre_Master__c();
            tm.RecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Draft').getRecordTypeId();
            tm.ETT_Tyre_Size__c = tyreSizeVsId.get(keyVsStagNewTyre.get(str).Size_Name__c);
            tm.ETT_Brand_Name__c = brandVsId.get(keyVsStagNewTyre.get(str).Brand_Name__c);
            tm.ETT_Country_Name__c = countryVsId.get(keyVsStagNewTyre.get(str).Country_Name__c);
            tm.ETT_Original_Pattern__c = patternVsId.get(keyVsStagNewTyre.get(str).Pattern_Name__c);
            tm.ETT_Collection_Card__c =  keyVsStagNewTyre.get(str).Collection_Card__c;
            insertNewTyreMasterList.add(tm);
        }
        
        if(insertNewTyreMasterList.size()>0 && insertNewTyreMasterList != null){
            insert insertNewTyreMasterList;
            for(id idval : collCCIdVshasNewTyrewoPrice.keyset() ){
                ETT_Collection_Card__c cc = new ETT_Collection_Card__c();
                cc.Id = idval;
                cc.HasTyresWithoutPrice__c = collCCIdVshasNewTyrewoPrice.get(idval);
                ccUpdateList.add(cc);   
                
            }
            update ccUpdateList;
        }
        
    }
    
}