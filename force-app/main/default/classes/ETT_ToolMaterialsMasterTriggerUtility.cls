public class ETT_ToolMaterialsMasterTriggerUtility{
    public static void preProcessingAllocation(List<ETT_Tools_Master__c> newList,Map<Id,ETT_Tools_Master__c> oldMap){
    
    }
    
    public static void postProcessingAllocation(List<ETT_Tools_Master__c> newList,Map<Id,ETT_Tools_Master__c> oldMap){
    }
    
    public static void preProcessingAllocation(List<ETT_Tools_Allocation__c> newList,Map<Id,ETT_Tools_Allocation__c> oldMap){
        Map<Id,ETT_Tools_Master__c> toolMasterMap=new Map<Id,ETT_Tools_Master__c>();
        
        for(ETT_Tools_Allocation__c ta:newList){
            if(String.isNotBlank(ta.Allocation_Status__c)){
                toolMasterMap.put(ta.ETT_Tools_Master__c,null);
            }
        }
        
        for(ETT_Tools_Master__c tm:[Select Id,Name,ETT_Item_Description__c,ETT_Status__c,ETT_Unit_type__c,ETT_Unique_Code__c,ETT_Tool_type__c,ETT_Maintenance_Frquency__c,ETT_Usage_type__c,ETT_Serial_No__c,ETT_Total_Unallocated_Stock_Value__c from ETT_Tools_Master__c where Id IN:toolMasterMap.keyset()]){
            toolMasterMap.put(tm.Id,tm);
        }
        
        for(ETT_Tools_Allocation__c ta:newList){ 
            if(oldMap!=null && oldMap.get(ta.Id).Allocation_Status__c!= ta.Allocation_Status__c){     
                if(ta.Allocation_Status__c=='Approved by Storekeeper' || ta.Allocation_Status__c=='Approved'){
                    if(ta.ETT_Allocated_Units_to_Station__c <1){
                        ta.AddError('Allocated units to station to be greater than 0');
                    }
                    else if((toolMasterMap.get(ta.ETT_Tools_Master__c).ETT_Usage_type__c=='Consumable' || toolMasterMap.get(ta.ETT_Tools_Master__c).ETT_Usage_type__c=='Depreciable') && toolMasterMap.get(ta.ETT_Tools_Master__c).ETT_Total_Unallocated_Stock_Value__c < ta.ETT_Allocated_Stocks__c){
                        ta.AddError('Allocated stocks are not matching with stock level for the master record. please add more stocks before approving allocation.');
                    }
                    else if(toolMasterMap.get(ta.ETT_Tools_Master__c).ETT_Status__c!='Available'){
                        ta.AddError('Related tool/material master should be in available status before approving alloation.');
                    }
                    else if(toolMasterMap.get(ta.ETT_Tools_Master__c).ETT_Unit_type__c=='Individual product' && String.isBlank(toolMasterMap.get(ta.ETT_Tools_Master__c).ETT_Serial_No__c)){
                        ta.AddError('Related tool/material master should have serial no if the master\'s unit type is "Individual product".');
                    }
                    
                    if(ta.Allocation_Status__c=='Approved'){
                        ta.ETT_Usage_Start_time__c=System.now();
                    }
                }
            }
        }
    }
    
    public static void postProcessingAllocation(List<ETT_Tools_Allocation__c> newList,Map<Id,ETT_Tools_Allocation__c> oldMap){
        Map<Id,ETT_Tools_Master__c> toolMasterMap=new Map<Id,ETT_Tools_Master__c>();
        List<ETT_Tools_Master__c> toolMasterToUpdate=new List<ETT_Tools_Master__c>();
        List<ETT_Tools_Allocation__c> toolAllocationToUpdate=new List<ETT_Tools_Allocation__c>();
        Map<Id,ETT_Tools_Allocation__c> toolAllocatonMap=new Map<Id,ETT_Tools_Allocation__c>();
        
        for(ETT_Tools_Allocation__c ta:newList){
            if(String.isNotBlank(ta.Allocation_Status__c)){
                toolMasterMap.put(ta.ETT_Tools_Master__c,null);
            }
            toolAllocatonMap.put(ta.Id,null);
        }
        
        if(toolAllocatonMap.keyset() !=null && toolAllocatonMap.keyset().size() >0){
            toolAllocatonMap=new Map<Id,ETT_Tools_Allocation__c>([Select Id,ETT_Previous_Tools_Allocation__c,ETT_Previous_Tools_Allocation__r.ETT_Tools_Master__c,ETT_Previous_Tools_Allocation__r.ETT_Available_Stocks__c,ETT_Previous_Tools_Allocation__r.ETT_Tools_Master__r.ETT_Usage_type__c from ETT_Tools_Allocation__c where Id IN:toolAllocatonMap.keyset()]);
        }
        for(ETT_Tools_Master__c tm:[Select Id,Name,ETT_Item_Description__c,ETT_Unit_type__c,ETT_Status__c,ETT_Unique_Code__c,ETT_Tool_type__c,ETT_Maintenance_Frquency__c,ETT_Usage_type__c,ETT_Serial_No__c from ETT_Tools_Master__c where Id IN:toolMasterMap.keyset()]){
            toolMasterMap.put(tm.Id,tm);
        }
        
        for(ETT_Tools_Allocation__c ta:newList){            
            if(oldMap!=null && oldMap.get(ta.Id).Allocation_Status__c!= ta.Allocation_Status__c){
                if(ta.Allocation_Status__c=='Approved' && ta.ETT_Previous_Tools_Allocation__c!=null){
                    ETT_Tools_Allocation__c newTa=new ETT_Tools_Allocation__c(Id=ta.ETT_Previous_Tools_Allocation__c);
                    if(toolAllocatonMap.get(ta.Id).ETT_Previous_Tools_Allocation__r.ETT_Tools_Master__r.ETT_Usage_type__c=='Consumable' && toolAllocatonMap.get(ta.Id).ETT_Previous_Tools_Allocation__r.ETT_Available_Stocks__c>0){
                       newTa.Allocation_Status__c='Almost Used';
                    }
                    else{
                       newTa.Allocation_Status__c='Obsolete';
                       newTa.ETT_Usage_End_time__c=System.now();
                    }
                    
                    toolAllocationToUpdate.add(newTa);
                    if(toolMasterMap.get(ta.ETT_Tools_Master__c).ETT_Unit_type__c=='Individual product'){
                        toolMasterToUpdate.add(new ETT_Tools_Master__c(Id=toolAllocatonMap.get(ta.Id).ETT_Previous_Tools_Allocation__r.ETT_Tools_Master__c,ETT_Status__c='Obsolete'));
                    }                    
                }
                else if(ta.Allocation_Status__c=='Rejected' && toolMasterMap.get(ta.ETT_Tools_Master__c).ETT_Unit_type__c=='Individual product'){
                    toolMasterToUpdate.add(new ETT_Tools_Master__c(Id=ta.ETT_Tools_Master__c,ETT_Status__c='Rejected'));
                }
            }
        }
        
        if(toolAllocationToUpdate.size() >0){
            update toolAllocationToUpdate;
        }
        if(toolMasterToUpdate.size() >0){
            update toolMasterToUpdate;
        }
    }
}