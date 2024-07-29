/**
 * Author:Janardhan Muddana
 * CreatedDate: 02-01-2022
 * TestClass: ETT_createJobCardsFromTyreInventTest
 * */
public class ETT_createJobCardsFromTyreInvent {
    
    @auraEnabled 
    public static list<ETT_Tyre_Inventory__c> getTyreDetails(){
        
        
        return [SELECT Id,Name,ETT_Tyre_Size_Master__r.Name,Serial_Number__c,ETT_Brand__r.Name,ETT_Pattern__r.Name,Party_Type__c,ETT_Country__r.Name,ETT_Collection_Card__r.Name,ETT_Account__r.Name from ETT_Tyre_Inventory__c where Id NOT IN (SELECT Tyre_Inventory__c FROM ETT_Job_Card__c) AND ETT_Inventory_Status__c='Inspected - Approved'  LIMIT 30000];
    }
    
    @auraEnabled 
    public static list<ETT_Job_Card__c> createJobCards(list<ETT_Tyre_Inventory__c> selectedTyres,String customerId){
        
        Savepoint sp = Database.setSavepoint();
        
        List<ETT_Job_Card__c> listOfJobCards = new List<ETT_Job_Card__c>();
        try{
            
            List<ETT_Inspection_Card__c> lstInspectionCards = [SELECT Id,Recordtype.name,Tyre_Inventory__c, ETT_Collection_Card__c, ETT_Status__c, (select Id from Job_Cards__r)
                                                               FROM ETT_Inspection_Card__c 
                                                               where ETT_Status__c = 'Accept' AND Tyre_Inventory__c=:selectedTyres];
             system.debug('---'+lstInspectionCards);
            for(ETT_Inspection_Card__c objIC:lstInspectionCards){
                if(objIC.Job_Cards__r.size()==0){
                    system.debug('entered');
                    ETT_Job_Card__c objJobCard = new ETT_Job_Card__c();
                    objJobCard.ETT_Inspection_Card__c = objIC.Id;
                    //include conditional values to stage order based on tyre record type (repair or retreading), For repair few stages are not applicable
                    if(objIC.recordType.name=='Tyre - Refurbishing Services'){
                        objJobCard.ETT_Job_Stages_to_Perform_Ordered__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building;Rimming & Enveloping;Curing;Removal of RIM Tube Flap;Final Inspection;Painting;Quality Control';
                    }
                    else{
                        objJobCard.ETT_Job_Stages_to_Perform_Ordered__c='Buffing;Skiving;Repair;Cementing;Filling;Thread Preparation;Building;Rimming & Enveloping;Curing;Removal of RIM Tube Flap;Final Inspection;Painting;Quality Control';//for other record types this will be updated later
                    }
                    objJobCard.Tyre_Inventory__c=objIC.Tyre_Inventory__c;
                    objJobCard.ETT_Stages__c = 'Buffing'; 
                    objJobCard.ETT_No_of_Buffing_revisions__c=1; 
                    objJobCard.ETT_Priority__c='Medium';
                    objJobCard.Customer__c = customerId;
                    listOfJobCards.add(objJobCard);
                }else{
                     throw new AuraHandledException('Job Card is created already.');
                }
            }
            insert listOfJobCards;
            
           
                     
            for(ETT_Tyre_Inventory__c tyre : selectedTyres){
                tyre.ETT_Inventory_Status__c = 'Job Card Created';
            }
            if(listOfJobCards.size()>0){
                update selectedTyres;
                
                /** Misc and Misc Line Creation **/
                /*map<string,list<string>> itemCodeVsSerialNos = new map<string,list<string>>();
                map<string,Id> itemCodeVsMiscLineId = new map<string,Id>();
                list<ETT_Misc_Line__c> miscLineList = new list<ETT_Misc_Line__c>();
                set<string> serialNoSet = new  set<string>();
                
                list<ETT_Job_Card__c> jcList =  [select id,Tyre_Inventory__c,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.Item_Code__c from ETT_Job_Card__c where Id=:listOfJobCards];
                for(ETT_Job_Card__c jc : jcList){
                    serialNoSet.add(jc.Tyre_Inventory__r.Serial_Number__c);
                    if(!itemCodeVsSerialNos.containsKey(jc.Tyre_Inventory__r.Item_Code__c)) {
                        itemCodeVsSerialNos.put(jc.Tyre_Inventory__r.Item_Code__c, new List<string>());
                    }
                    itemCodeVsSerialNos.get(jc.Tyre_Inventory__r.Item_Code__c).add(jc.Tyre_Inventory__r.Serial_Number__c);
                    
                }
                
                ETT_Miscellaneous__c misc = new ETT_Miscellaneous__c();
                misc.Misc_Type__c = 'Issue';
                misc.Transaction_Type__c ='JOB_CARD_OPN_USED_TYRE';
                insert misc;
                integer i=1;
                for(string str : itemCodeVsSerialNos.keyset()){
                    ETT_Misc_Line__c miscLine = new ETT_Misc_Line__c();
                    miscLine.Line_Number__c = i;
                    miscLine.Item_Code__c = str;
                    miscLine.Misc_Header__c = misc.Id;
                    miscLine.Quantity__c = itemCodeVsSerialNos.get(str).size();
                    miscLine.Org_ID__c='426';
                    miscLine.Sub_Inventory__c ='AUH-TF-MS';
                    miscLine.Locator__c = 'AUH-TF-MS.Used Tyres.0';
                    miscLine.Serial_Control_Flag__c='Y';
                    miscLineList.add(miscLine);
                    i++;
                }
                insert miscLineList;
                for(ETT_Misc_Line__c line : miscLineList){
                    itemCodeVsMiscLineId.put(line.Item_Code__c,line.Id);
                }
                list<ETT_Tyre_Inventory__c> updatedTyreInvList = new list<ETT_Tyre_Inventory__c>();
                
                for(ETT_Tyre_Inventory__c tyre : [select id,Item_Code__c,Serial_Number__c from ETT_Tyre_Inventory__c where Serial_Number__c=:serialNoSet]){
                    
                    if(itemCodeVsMiscLineId.containskey(tyre.Item_Code__c)){
                        tyre.Misc_Line__c = itemCodeVsMiscLineId.get(tyre.Item_Code__c);
                        updatedTyreInvList.add(tyre);
                    }
                }
                update updatedTyreInvList;*/
                
            }
           return listOfJobCards;
            
        }catch(Exception e){
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());
            system.debug('---err-'+e.getMessage());
             Database.rollback(sp);
            throw new AuraHandledException(e.getMessage()+'--'+e.getCause()+'--'+e.getStackTraceString()); 
        }    
    }
}