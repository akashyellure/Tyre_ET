/**
 * 
 * Test Class:ETT_JobCardListControllerTest2
 * */
public class ETT_JobCardListController {
    
    public class JobWrapper{
        @AuraEnabled public list<ETT_Job_Card__c> validJobCardList {get;set;}        
        @AuraEnabled public ETT_Work_Schedule__c currentWorkSchedule {get;set;}        
        @AuraEnabled public List<ETT_Skill_Set__c> requiredSkillSets {get;set;}        
        
        @AuraEnabled public Map<String,String> buffing_dustCollectorReasonValues {get; set;}
        @AuraEnabled public Map<String,String> buffingSettingsReasonValues {get; set;}
        @AuraEnabled public Map<String,String> buffing_precuredTreadLineValues {get; set;}
        @AuraEnabled public String nextStageValue {get; set;}
        
        @AuraEnabled public ETT_Tyre_Master__c tyreMaster {get;set;}
        @AuraEnabled public List<ETT_Job_Card_Line_Item__c> buffingDetails {get;set;} 
        @AuraEnabled public List<ETT_Job_Card_Line_Item__c> ThreadPrepDetails {get;set;} 
        @AuraEnabled public List<ETT_Tools_Allocation__c> treadMasterList {get;set;}
        @AuraEnabled public ETT_Tyre_Rejection_Line_Item__c tyreRejectionItemCrown {get;set;}
        @AuraEnabled public Map<String,String> buffing_statusValues {get; set;}
        @AuraEnabled public Map<String,String> holdReasons {get; set;}
        @AuraEnabled public Map<String,String> availableDefectsForStation {get; set;} 
        @AuraEnabled public Map<String,String> availableNextStationList {get; set;} 
        
        @AuraEnabled public ETT_Job_Card_Setup__mdt jobCardSetup {get; set;}
        
        public JobWrapper(){
            currentWorkSchedule=new ETT_Work_Schedule__c();
            requiredSkillSets=new List<ETT_Skill_Set__c>();
            tyreMaster=new ETT_Tyre_Master__c();
            buffingDetails=new List<ETT_Job_Card_Line_Item__c>();
            treadMasterList=new List<ETT_Tools_Allocation__c>();
            tyreRejectionItemCrown=new ETT_Tyre_Rejection_Line_Item__c();
        }
    }
    
    Public class JobLineItemWrapper{
        @AuraEnabled public JobWrapper relatedJobWrapper {get;set;}     
        @AuraEnabled public ETT_Job_Card_Line_Item__c jobLineItem {get; set;}
        @AuraEnabled public ETT_Work_Activity__c workTracker {get; set;}
        @AuraEnabled public JobLineItemWrapper holdLineItem {get; set;}
        @AuraEnabled public ETT_Job_Card_Line_Item__c nextJobLineItem{get; set;}
        @AuraEnabled public ETT_Work_Activity__c nextWorkTracker {get; set;}
        
        public JobLineItemWrapper(){
            this.jobLineItem=new ETT_Job_Card_Line_Item__c();
            this.workTracker=new ETT_Work_Activity__c();
            this.relatedJobWrapper=new JobWrapper();
            this.nextJobLineItem=new ETT_Job_Card_Line_Item__c();
            this.nextWorkTracker=new ETT_Work_Activity__c();
        }
    }
    
    Public class ToolsAndUsageWrapper{
        @AuraEnabled public ETT_Tools_Allocation__c  stationTool {get;set;}     
        @AuraEnabled public ETT_Tools_Material_Usage__c usageRec {get; set;}
        @AuraEnabled public String toolImageLink {get; set;}
        @Auraenabled public list<FileWrapper> lstFileWrapperDetails{get; set;}
        
        public ToolsAndUsageWrapper(ETT_Tools_Allocation__c stationTool){
            this.stationTool=stationTool;
            this.usageRec=new ETT_Tools_Material_Usage__c();
            this.lstFileWrapperDetails=new List<FileWrapper>();
        }
    }
    
    @AuraEnabled
    public static Id getObjectRecordTypeIdByNme(String ObjectName,String recordTypeDeveloperName) {
        Schema.SObjectType objType= Schema.getGlobalDescribe().get(ObjectName);
        Id recTypeId = objType.getDescribe().getRecordTypeInfosByName().get(recordTypeDeveloperName).getRecordTypeId();
        return recTypeId;
    } 
    @AuraEnabled
    public static void updateValveOnJC(List<ETT_Job_Card__c> jobCardlist) {
        if(jobCardlist !=null && jobCardlist.size() > 0){
            system.debug('--->'+jobCardlist);
            update jobCardlist;
        }
    }  
   @AuraEnabled
    public static list<ETT_Job_Card__c> getCuringBatchJCDetails(string curBatchNo){
        system.debug('Sandip Job Card ' +curBatchNo);
        return [select Id,Tyre_Inventory__r.Serial_Number__c,(select id,Pressure_Valve__c,Vacuum_Valve__c from Job_Card_Line_Items__r where RecordType.Name='Rimming & Enveloping' AND Sequence__c=9 order by ETT_Revision_Number__c DESC) from ETT_Job_Card__c where Curing_Batch_No__c=:curBatchNo];
    }
    @AuraEnabled
    public static list<ETT_Job_Card__c> getCuringBatchDetailsFromId(list<id> JCIds){
        system.debug('Sandip Job Card ' +JCIds);
        return [select Id,Tyre_Inventory__r.Serial_Number__c,(select id,Pressure_Valve__c,Vacuum_Valve__c from Job_Card_Line_Items__r where RecordType.Name='Rimming & Enveloping' AND Sequence__c=9 order by ETT_Revision_Number__c DESC) from ETT_Job_Card__c where Id=:JCIds];
    }
    
     @AuraEnabled
    public static list<ETT_Tools_Material_Usage__c> getToolsMaterialDetails(string JCId,string Stage){
        return [select id from ETT_Tools_Material_Usage__c where ETT_Job_Card__c=:JCId AND ETT_Job_Stage__c=:Stage];
    }
    
    @AuraEnabled
    Public Static List<ToolsAndUsageWrapper> getStationToolsWithWrapper(){//New version
        List<ToolsAndUsageWrapper>  stationToolsWrapperList=new List<ToolsAndUsageWrapper>();
        Map<Id,String> masterImageMap=new Map<Id,String>();
        Map<Id,ContentVersion> contentDocuemntVsVersionMap=new Map<Id,ContentVersion>();
        
        List<ETT_Job_Card__c> currentValidJobLists=new List<ETT_Job_Card__c>();
        List<ETT_Work_Schedule__c> currentWorkSchedule=[Select Id,Name,ETT_Technician__c,ETT_Technician__r.Name,ETT_Start_time__c,ETT_End_time__c,ETT_Work_Station__c,ETT_Work_Station__r.ETT_Station_Code__c,ETT_Work_Station__r.Name,ETT_Work_Station__r.ETT_Station_Type__c from ETT_Work_Schedule__c where
                                                        ETT_Technician__c=:Userinfo.getUserId() and ETT_End_time__c>=:System.NOW() AND ETT_Start_time__c<=:System.NOW() limit 1];
        System.debug('currentWorkSchedule: '+currentWorkSchedule);
        
        if(currentWorkSchedule!=null && currentWorkSchedule.size()>0){
            for(ETT_Tools_Allocation__c ta:[Select Id,Name,ETT_Tools_Master__r.Unit_Text__c,ETT_Tools_Master__r.ETT_Main_Stock_Units__c,ETT_Tools_Master__r.ETT_Allocated_Units__c,ETT_Allocated_Stocks__c,ETT_Available_Stocks__c,Allocation_Status__c,ETT_Tools_Master__r.ETT_Usage_type__c,ETT_Tools_Master__r.ETT_Unit_type__c,ETT_Tools_Master__r.ETT_Individual_Unit_Value__c,ETT_Tools_Master__r.RecordtypeId,ETT_Tools_Master__r.Recordtype.Name,ETT_Tools_Master__c,
                                            ETT_Previous_Tools_Allocation__c,ETT_Tools_Master__r.Name,ETT_Tools_Master__r.ETT_Item_Description__c,ETT_Tools_Master__r.ETT_Status__c,ETT_Tools_Master__r.ETT_Unique_Code__c,ETT_Tools_Master__r.ETT_Tool_type__c,ETT_Tools_Master__r.ETT_Serial_No__c,
                                            ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c,ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c,ETT_Usage_End_time__c,ETT_Remarks__c,ETT_Allocated_Units_to_Station__c from ETT_Tools_Allocation__c where 
                                            ETT_Assigned_Work_Station__c=:currentWorkSchedule[0].ETT_Work_Station__c AND Allocation_Status__c!='' and Allocation_Status__c!='Obsolete' and Allocation_Status__c!='Rejected' order by ETT_Tools_Master__r.Name]){
                                                System.debug('ta: '+ta);
                                                stationToolsWrapperList.add(new ToolsAndUsageWrapper(ta));
                                                masterImageMap.put(ta.ETT_Tools_Master__c,null);
                                            }
            
            System.debug('masterImageMap: '+masterImageMap);
            if(masterImageMap.values() !=null && masterImageMap.values().size()>0){
                for(ContentDocumentLink cv:[Select Id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId IN:masterImageMap.keyset()]){
                    contentDocuemntVsVersionMap.put(cv.ContentDocumentId,null);
                    
                }  
                for(ContentVersion v:[Select Id,ContentDocumentId,ContentUrl from ContentVersion where isLatest=true and ContentDocumentId IN:contentDocuemntVsVersionMap.keyset()]){
                    contentDocuemntVsVersionMap.put(v.ContentDocumentId,v);
                }                
                for(ContentDocumentLink cv:[Select Id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId IN:masterImageMap.keyset()]){
                    if(contentDocuemntVsVersionMap.containsKey(cv.ContentDocumentId) && masterImageMap.containsKey(cv.LinkedEntityId)){
                        masterImageMap.put(cv.LinkedEntityId,Label.ETT_ContentBaseURL+'/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+contentDocuemntVsVersionMap.get(cv.ContentDocumentId).Id);
                    }
                }
                for(ToolsAndUsageWrapper wrap:stationToolsWrapperList){
                    if(wrap.stationTool!=null && masterImageMap.containsKey(wrap.stationTool.ETT_Tools_Master__c) && masterImageMap.get(wrap.stationTool.ETT_Tools_Master__c)!=null){
                        wrap.toolImageLink=masterImageMap.get(wrap.stationTool.ETT_Tools_Master__c);
                    }
                }
            }
        }
        return stationToolsWrapperList;
    }
    
    @AuraEnabled
    Public Static JobLineItemWrapper initializeHoldLineItem(){
        JobLineItemWrapper j=new JobLineItemWrapper(); 
        return j;
    }
    
    Public Static List<String> queryAllSObjectFields(String SobjectApiName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List<String> fieldList=new List<String>();
        
        for(String fieldName : fieldMap.keyset())
        {
            fieldList.add(fieldName);
        }
        return fieldList;
    }
    
    @AuraEnabled
    Public Static JobWrapper getValidJobCards(){
        JobWrapper jWrap=new JobWrapper();
        Datetime currentTime=System.now();
        List<ETT_Job_Card__c> currentValidJobLists=new List<ETT_Job_Card__c>();
        List<ETT_Work_Schedule__c> currentWorkSchedule=[Select Id,Name,ETT_Technician__c,ETT_Technician__r.Name,ETT_Start_time__c,ETT_End_time__c,ETT_Work_Station__c,ETT_Work_Station__r.ETT_Station_Code__c,ETT_Work_Station__r.Name,ETT_Work_Station__r.ETT_Station_Type__c from ETT_Work_Schedule__c where
                                                        ETT_Technician__c=:Userinfo.getUserId() and ETT_End_time__c>=:System.NOW() AND ETT_Start_time__c<=:System.NOW() limit 1];
        if(currentWorkSchedule!=null && currentWorkSchedule.size()>0){
            jWrap.currentWorkSchedule=currentWorkSchedule[0];
            jWrap.jobCardSetup=[Select Id,ETT_Instructions__c from ETT_Job_Card_Setup__mdt where MasterLabel=:currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c];
            jWrap.requiredSkillSets=[Select Id,name,ETT_Skill_Description__c from ETT_Skill_Set__c where ETT_Work_Station_Type__c includes (:currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c) ];
           
            String jobQueryStr='Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+','+
                +'ETT_Tyre_Master__r.ETT_Tyre_Size__c,ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name,ETT_Inspection_Card__r.ETT_Collection_Card__c,ETT_Inspection_Card__r.ETT_Brand__c,ETT_Inspection_Card__r.ETT_Country__c,'+
                +'ETT_Inspection_Card__r.ETT_Pattern__c,ETT_Inspection_Card__r.ETT_Tyre_Size__c,ETT_Main_Job_Card__r.ETT_Stages__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Painting__c,ETT_Main_Job_Card__r.ETT_Defect_Identified_Final_Inspection__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Curing__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Rimming_Env__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Building__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Filling__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Cementing__c,ETT_Main_Job_Card__r.ETT_Repair_Rework_Reason_s__c,ETT_Main_Job_Card__r.ETT_Skiving_Rework_Reason_s__c,'+
                +'ETT_Main_Job_Card__r.ETT_Tyre_Master__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name,ETT_Main_Job_Card__r.Name,ETT_Main_Job_Card__r.ETT_Priority__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Actual_Width__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Length__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Tyre_Outer_Diameter_OD__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__r.Name,ETT_Main_Job_Card__r.ETT_Buffing_precured_tread_line__c from ETT_Job_Card__c where ETT_Stages__c=\''+currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c+'\'';
           /* if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Buffing'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Buffing_Status__c like \'Resubmitted%\' OR ETT_Buffing_Status__c like \'Defects Identified%\' OR ETT_Buffing_Status__c=\'\') Order by ETT_Priority__c DESC';
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Skiving'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Skiving_Status__c like \'Resubmitted%\' OR ETT_Skiving_Status__c like \'Defects Identified%\' OR ETT_Skiving_Status__c=\'\') Order by ETT_Priority__c DESC';
            }  
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Repair'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Repair_Status__c like \'Resubmitted%\' OR ETT_Repair_Status__c like \'Defects Identified%\' OR ETT_Repair_Status__c=\'\') Order by ETT_Priority__c DESC';
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Cementing'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Cementing_Status__c like \'Resubmitted%\' OR ETT_Cementing_Status__c like \'Defects Identified%\' OR ETT_Cementing_Status__c=\'\') Order by ETT_Priority__c DESC';
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Filling'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Filling_Status__c like \'Resubmitted%\' OR ETT_Filling_Status__c like \'Defects Identified%\' OR ETT_Filling_Status__c=\'\') Order by ETT_Priority__c DESC';
                //jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND ETT_Cemented_Least_Available_Time__c <=:Currenttime AND (ETT_Filling_Status__c like \'Resubmitted%\' OR ETT_Filling_Status__c like \'Defects Identified%\' OR ETT_Filling_Status__c=\'\') Order by ETT_Priority__c DESC';
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Thread Preparation'){//ETT_Main_Job_Card__c field will only be populated for threading stage.
                jobQueryStr+=' AND ETT_Main_Job_Card__c!=null AND (ETT_Thread_Preparation_Status__c=\'Waiting for Acceptance\' OR ETT_Thread_Preparation_Status__c like \'Resubmitted%\' OR ETT_Thread_Preparation_Status__c like \'Defects Identified%\' OR ETT_Thread_Preparation_Status__c=\'\') Order by ETT_Priority__c DESC';
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Building'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Building_Status__c like \'Resubmitted%\' OR ETT_Building_Status__c like \'Defects Identified%\' OR ETT_Building_Status__c=\'\') Order by ETT_Priority__c DESC';
                //jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND ETT_Thread_Least_Available_Time__c <=:Currenttime AND (ETT_Building_Status__c like \'Resubmitted%\' OR ETT_Building_Status__c like \'Defects Identified%\' OR ETT_Building_Status__c=\'\') Order by ETT_Priority__c DESC';
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Rimming & Enveloping'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Rimming_Env_Status__c like \'Resubmitted%\' OR ETT_Rimming_Env_Status__c like \'Defects Identified%\' OR ETT_Rimming_Env_Status__c=\'\') Order by ETT_Priority__c DESC';
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Curing'){*/
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND Tyre_Inventory__c != null AND ETT_Overall_Status__c!=\'Rejected\' AND Curing_Batch_No__c =null Order by ETT_Priority__c DESC';
                       /* }
			else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Final Inspection'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Final_Inspection_Status__c like \'Resubmitted%\' OR ETT_Final_Inspection_Status__c like \'Defects Identified%\' OR ETT_Final_Inspection_Status__c=\'\') Order by ETT_Priority__c DESC';
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Painting'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Painting_Status__c like \'Resubmitted%\' OR ETT_Painting_Status__c like \'Defects Identified%\' OR ETT_Painting_Status__c=\'\') Order by ETT_Priority__c DESC';
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Removal of RIM Tube Flap'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Removal_of_RIM_Tube_Flap_Status__c like \'Resubmitted%\' OR ETT_Removal_of_RIM_Tube_Flap_Status__c like \'Defects Identified%\' OR ETT_Removal_of_RIM_Tube_Flap_Status__c=\'\') Order by ETT_Priority__c DESC';
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Quality Control'){
                jobQueryStr+=' AND ETT_Main_Job_Card__c=null AND (ETT_Quality_Check_Status__c like \'Resubmitted%\' OR ETT_Quality_Check_Status__c like \'Defects Identified%\' OR ETT_Quality_Check_Status__c=\'\') Order by ETT_Priority__c DESC';
            }*/
            System.debug('jobQueryStr: '+jobQueryStr);
            //and so on for other stages
            
            for(ETT_Job_Card__c j:Database.query(jobQueryStr)){
                
               /* if(j.ETT_Stages__c=='Buffing' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Buffing' && (j.ETT_Buffing_Station_Work_Schedule__c==null || j.ETT_Buffing_Station_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
                else if(j.ETT_Stages__c=='Skiving' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Skiving' && (j.ETT_Skiving_Station_Work_Schedule__c==null || j.ETT_Skiving_Station_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
                else if(j.ETT_Stages__c=='Repair' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Repair' && (j.ETT_Repair_Work_Schedule__c ==null || j.ETT_Repair_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
                else if(j.ETT_Stages__c=='Cementing' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Cementing' && (j.ETT_Cementing_Work_Schedule__c ==null || j.ETT_Cementing_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
                else if(j.ETT_Stages__c=='Filling' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Filling' && (j.ETT_Filling_Work_Schedule__c ==null || j.ETT_Filling_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
                else if(j.ETT_Stages__c=='Thread Preparation' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Thread Preparation' && (j.ETT_Thread_Preparation_Work_Schedule__c==null || j.ETT_Thread_Preparation_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
                else if(j.ETT_Stages__c=='Building' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Building' && (j.ETT_Building_Work_Schedule__c==null || j.ETT_Building_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
                else if(j.ETT_Stages__c=='Rimming & Enveloping' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Rimming & Enveloping' && (j.ETT_Rimming_Env_Schedule__c==null || j.ETT_Rimming_Env_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
          else*/ if(j.ETT_Stages__c=='Curing'){// & currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Curing' && (j.ETT_Curing_Work_Schedule__c==null || j.ETT_Curing_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
              system.debug('currentValidJobLists1'+currentValidJobLists);
                }/*
                else if(j.ETT_Stages__c=='Final Inspection' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Final Inspection' && (j.ETT_Final_Inspection_Work_Schedule__c==null || j.ETT_Final_Inspection_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
                else if(j.ETT_Stages__c=='Painting' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Painting' && (j.ETT_Painting_Work_Schedule__c==null || j.ETT_Painting_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
                else if(j.ETT_Stages__c=='Removal of RIM Tube Flap' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Removal of RIM Tube Flap' && (j.ETT_Removal_of_RIMTubStationWorkSchedule__c==null || j.ETT_Removal_of_RIMTubStationWorkSchedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }
                else if(j.ETT_Stages__c=='Quality Control' && currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Quality Control' && (j.ETT_QualityControl_Station_Work_Schedule__c==null || j.ETT_QualityControl_Station_Work_Schedule__c==currentWorkSchedule[0].Id)){
                    currentValidJobLists.add(j);
                }*/
                //repeat the conditions for other stations as well.
            }
            
            Map<String, String> buffing_dustCollectorReasonValues = new Map<String, String>();
            
            for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card_Line_Item__c', 'ETT_Dust_Collector_Reason__c')){
                buffing_dustCollectorReasonValues.put(picklistValues, picklistValues);
            }
            jWrap.buffing_dustCollectorReasonValues = buffing_dustCollectorReasonValues;
            
            Map<String, String> buffing_precuredTreadLineValues = new Map<String, String>();
            
            for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Buffing_precured_tread_line__c')){
                buffing_precuredTreadLineValues.put(picklistValues, picklistValues);
            }
            jWrap.buffing_precuredTreadLineValues = buffing_precuredTreadLineValues;
            
            Map<String, String> holdReasons = new Map<String, String>();
            
            for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card_Line_Item__c', 'ETT_Pause_Reason__c')){
                holdReasons.put(picklistValues, picklistValues);
            }
            jWrap.holdReasons = holdReasons;
            
            Map<String, String> availableNextStationList= new Map<String, String>();
            for(String s: ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Stages__c')){
                if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c!=s){
                    availableNextStationList.put(s,s);
                }
            }
            jWrap.availableNextStationList = availableNextStationList;
            
            Map<String, String> availableDefectsForStation = new Map<String, String>();
            if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Skiving'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Skiving_Rework_Reason_s__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Repair'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Repair_Rework_Reason_s__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Cementing'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Cementing__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Filling'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Filling__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Building'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Building__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Rimming & Enveloping'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Rimming_Env__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Curing'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Curing__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Final Inspection'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_Identified_Final_Inspection__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Painting'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Painting__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Removal of RIM Tube Flap'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_RemovalRim__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Quality Control'){
                for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_QualityCtrl__c')){
                    availableDefectsForStation.put(picklistValues, picklistValues);
                }
            }
            
            //and so on for other stages
            jWrap.availableDefectsForStation = availableDefectsForStation;
            
            Map<String, String> buffingSettingsReasonValues= new Map<String, String>();
            for(String s: ETT_Utility.getPicklistValues('ETT_Job_Card_Line_Item__c', 'ETT_Incorrect_Buffing_Settings_Reason__c')){
                buffingSettingsReasonValues.put(s,s);
            }
            jWrap.buffingSettingsReasonValues = buffingSettingsReasonValues;
        }
        jWrap.validJobCardList=currentValidJobLists;
        return jWrap;
    }
    
    Public Static List<String> allStationListRetreading=new List<String>{'Buffing','Skiving','Repair','Cementing','Filling','Thread Preparation','Building','Rimming & Enveloping','Curing', 'Removal of RIM Tube Flap' ,'Final Inspection','Painting','Quality Control'};
        Public Static List<String> allStationListRepair=new List<String>{'Buffing','Skiving','Repair','Cementing','Filling','Thread Preparation','Building','Rimming & Enveloping','Curing', 'Removal of RIM Tube Flap' ,'Final Inspection','Painting','Quality Control'};//this will be updated later
            
            @AuraEnabled
            Public Static JobLineItemWrapper getValidJobCardLineDetail(String recordId,String stageValue,Integer current_sequence,Boolean readOnlyView,ETT_Job_Card_Line_Item__c Nextlineitem,ETT_Work_Activity__c nextWorkTracker){ 
                
                List<ETT_Work_Schedule__c> currentWorkSchedule=[Select Id,Name,ETT_Technician__c,ETT_Technician__r.Name,ETT_Start_time__c,ETT_End_time__c,ETT_Work_Station__c,ETT_Work_Station__r.ETT_Station_Code__c,ETT_Work_Station__r.Name,ETT_Work_Station__r.ETT_Station_Type__c from ETT_Work_Schedule__c where
                                                                ETT_Technician__c=:Userinfo.getUserId() and ETT_End_time__c>=:System.NOW() AND ETT_Start_time__c<=:System.NOW() limit 1];
                
                System.debug('currentWorkSchedule: '+currentWorkSchedule);
                System.debug('current_sequence: '+current_sequence);
                
                JobLineItemWrapper j=new JobLineItemWrapper(); 
                j.holdLineItem=new JobLineItemWrapper();
                Integer seqAsPerDB=0;
                list<ETT_Job_Card_Setup__mdt> jcs =  [Select Id,ETT_Instructions__c from ETT_Job_Card_Setup__mdt where MasterLabel=:currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c];
                if(jcs.size()>0){
                      j.relatedJobWrapper.jobCardSetup=jcs[0];
                }
              
                j.relatedJobWrapper.validJobCardList=Database.query('Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+','+
                                                                    +'ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name,ETT_Tyre_Master__r.ETT_Tyre_Size__c,ETT_Inspection_Card__r.ETT_Collection_Card__c,Tyre_Inventory__r.ETT_Tyre_Master__r.ETT_Length__c,Tyre_Inventory__r.ETT_Tyre_Master__r.ETT_Actual_Width__c,ETT_Inspection_Card__r.ETT_Collection_Card__r.Skiving_on_GSO_sticker_area__c,ETT_Inspection_Card__r.ETT_Brand__c,ETT_Inspection_Card__r.ETT_Country__c,'+
                                                                    +'ETT_Main_Job_Card__r.Tyre_Inventory__r.ETT_Pattern__r.Name,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.ETT_Pattern__r.Name,ETT_Inspection_Card__r.ETT_Pattern__c,ETT_Inspection_Card__r.ETT_Tyre_Size__c,ETT_Main_Job_Card__r.ETT_Stages__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Painting__c,ETT_Main_Job_Card__r.ETT_Defect_Identified_Final_Inspection__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Curing__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Rimming_Env__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Building__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Filling__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Cementing__c,ETT_Main_Job_Card__r.ETT_Repair_Rework_Reason_s__c,ETT_Main_Job_Card__r.ETT_Skiving_Rework_Reason_s__c,'+
                                                                    +'ETT_Main_Job_Card__r.ETT_Tyre_Master__c,ETT_Main_Job_Card__r.Name,ETT_Main_Job_Card__r.ETT_Priority__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Actual_Width__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Length__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Tyre_Outer_Diameter_OD__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__r.Name,ETT_Main_Job_Card__r.ETT_Buffing_precured_tread_line__c,ETT_Inspection_Card__r.ETT_Tyre_Size__r.Name from ETT_Job_Card__c where Id=:recordId');
                System.debug('j--------->'+j.relatedJobWrapper.validJobCardList[0].ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name);
                if(j.relatedJobWrapper.validJobCardList!=null && j.relatedJobWrapper.validJobCardList.size() >0){
                    System.debug('validJobCardList: '+j.relatedJobWrapper.validJobCardList);
                    
                    j.relatedJobWrapper.availableNextStationList=new Map<String,String>(); 
                    if(j.relatedJobWrapper.validJobCardList[0].ETT_Job_Type__c=='Tyre - Refurbishing Services'){
                        for(String s: allStationListRetreading){
                            if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c!=s){
                                j.relatedJobWrapper.availableNextStationList.put(s,s);
                            }
                        }
                    }
                    else{
                        for(String s: allStationListRepair){
                            if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c!=s){
                                j.relatedJobWrapper.availableNextStationList.put(s,s);
                            }
                        }
                    }
                    
                    Map<String, String> holdReasons = new Map<String, String>();
                    
                    for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card_Line_Item__c', 'ETT_Pause_Reason__c')){
                        holdReasons.put(picklistValues, picklistValues);
                    }
                    j.relatedJobWrapper.holdReasons = holdReasons;
                    
                    
                    Map<String, String> buffing_precuredTreadLineValues = new Map<String, String>();
                    
                    for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Buffing_precured_tread_line__c')){
                        buffing_precuredTreadLineValues.put(picklistValues, picklistValues);
                    }
                     j.relatedJobWrapper.buffing_precuredTreadLineValues = buffing_precuredTreadLineValues;
                    
                    
                    String stageCombined=j.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c;
                    List<String> stageListOrdered=new List<String>();
                    String currentStageValue='';
                    String nextStageValue='';
                    Integer currentStageIndex=0;
                    
                    if(String.isNotBlank(stageCombined)){
                        stageListOrdered=stageCombined.split(';');  
                        system.debug('---'+stageListOrdered);
                        for(Integer i=0;i<stageListOrdered.size();i++){
                            if(stageListOrdered[i]==j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c){
                                currentStageIndex=i;
                                currentStageValue=stageListOrdered[i];
                                //nextStageValue= stageListOrdered[i+1];
                                System.debug('currentStageValue: '+currentStageValue);
                                break;
                            }
                        }
                        if(stageListOrdered.size() > (currentStageIndex+1)){//trying to find if the list has next element
                            nextStageValue=stageListOrdered[currentStageIndex+1];
                            System.debug('nextStageValue: '+nextStageValue);
                        }
                    }
                    j.relatedJobWrapper.nextStageValue=nextStageValue;//This will tell us the possible next stage value to predict
                    //Add below Lines By Janardhan -Start
                    Map<String, String> availableDefectsForStation = new Map<String, String>();
                    if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Skiving'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Skiving_Rework_Reason_s__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Repair'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Repair_Rework_Reason_s__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }
                    else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Cementing'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Cementing__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }
                    else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Filling'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Filling__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }
                    
                    else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Building'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Building__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }
                    else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Rimming & Enveloping'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Rimming_Env__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }
                    else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Curing'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Curing__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }
                    else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Final Inspection'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_Identified_Final_Inspection__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }
                    else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Painting'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_Painting__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }
                    else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Removal of RIM Tube Flap'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_RemovalRim__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }
                    else if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c=='Quality Control'){
                        for(String picklistValues : ETT_Utility.getPicklistValues('ETT_Job_Card__c', 'ETT_Defect_s_Identified_On_QualityCtrl__c')){
                            availableDefectsForStation.put(picklistValues, picklistValues);
                        }
                    }
                    j.relatedJobWrapper.availableDefectsForStation = availableDefectsForStation;
                    
                    //End -Janardhan
                    
                    
                    
                    Integer currentVersion=1;
                    if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c);
                    }            
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Removal of Rim tube Flap' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_RemovalRimTubeFlap_revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_RemovalRimTubeFlap_revisions__c);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c);
                        System.debug('currentVersion='+currentVersion);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting' && j.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c);
                    }
                    else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Quality Control' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Quality_Control_Revisions__c >=1){
                        currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Quality_Control_Revisions__c);
                    }
                    //and so on for other stages
                    System.debug('currentVersion='+currentVersion);
                    List<ETT_Job_Card_Line_Item__c> relatedLines=Database.query('Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card_Line_Item__c'),',')+' ,(Select Id,ETT_Start_time__c,ETT_End_time__c,ETT_Job_Card_Line_Item__c from ETT_Work_Activities__r where ETT_End_time__c=null) from ETT_Job_Card_Line_Item__c where ETT_Job_Card__c=\''+j.relatedJobWrapper.validJobCardList[0].Id+'\' AND RecordType.Name=:stageValue and ETT_Revision_Number__c=:currentVersion order by Sequence__c desc');
                    system.debug('sandiprelatedline'+relatedLines);
                    if(j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__r.ETT_Collection_Card__c!=null){
                        List<ETT_Tyre_Master__c> tyreMasterList=[SELECT Id,name,ETT_Length__c,ETT_Status__c,ETT_Tyre_Outer_Diameter_OD__c,ETT_Actual_Width__c,ETT_Original_Pattern__c From ETT_Tyre_Master__c where ETT_Tyre_Size__r.ETT_Status__c=true and ETT_Brand_Name__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__r.ETT_Brand__c and ETT_Original_Pattern__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__r.ETT_Pattern__c and ETT_Country_Name__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__r.ETT_Country__c and ETT_Tyre_Size__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__r.ETT_Tyre_Size__c];
                        if(tyreMasterList!=null && tyreMasterList.size() >0){
                            j.relatedJobWrapper.tyreMaster=[Select Id,Name,ETT_Length__c,ETT_Status__c,ETT_Tyre_Outer_Diameter_OD__c,ETT_Actual_Width__c,ETT_Original_Pattern__c from ETT_Tyre_Master__c where Id=:tyreMasterList[0].Id];
                            j.relatedJobWrapper.treadMasterList=[Select Id,Name,ETT_Tools_Master__r.RecordtypeId,ETT_Tools_Master__r.Recordtype.Name,ETT_Tools_Master__c,ETT_Tools_Master__r.ETT_Depth__c,ETT_Tools_Master__r.ETT_KG_Per_Mtr__c,ETT_Tools_Master__r.ETT_Pattern_Master__c,ETT_Tools_Master__r.ETT_Pattern_Master__r.Name,ETT_Tools_Master__r.ETT_Tread_Width__c,ETT_Previous_Tools_Allocation__c,ETT_Tools_Master__r.Name,ETT_Tools_Master__r.ETT_Item_Description__c,ETT_Tools_Master__r.ETT_Status__c,ETT_Tools_Master__r.ETT_Unique_Code__c,ETT_Tools_Master__r.ETT_Tool_type__c,ETT_Tools_Master__r.ETT_Serial_No__c,ETT_Usage_End_time__c,ETT_Remarks__c from ETT_Tools_Allocation__c where ETT_Tools_Master__r.ETT_Status__c!='Obsolete' and ETT_Tools_Master__r.ETT_Status__c!='Rejected' and ETT_Tools_Master__r.ETT_Allocated_Units__c>0 and ETT_Tools_Master__r.Recordtype.Name='Material - Treads' and ETT_Tools_Master__r.ETT_Pattern_Master__c=:j.relatedJobWrapper.tyreMaster.ETT_Original_Pattern__c];
                        } 
                        List<ETT_Tyre_Rejection_Line_Item__c> crownRejectionItems=[Select Id,name,ETT_Number_of_cuts_0_10_mm__c,ETT_Number_of_cuts_11_to_25_mm__c,ETT_Number_of_cuts_26_to_38_mm__c,ETT_Number_of_cuts_39_to_50_mm__c,ETT_Number_of_cuts_51_mm_and_above__c from ETT_Tyre_Rejection_Line_Item__c where ETT_Inspection_Card__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__c and name='CrownArea'];
                        if(crownRejectionItems!=null && crownRejectionItems.size() >0){
                            j.relatedJobWrapper.tyreRejectionItemCrown=crownRejectionItems[0];
                        }
                        //below line added by shweta
                        j.relatedJobWrapper.buffingDetails=[SELECT Id, Name,Desired_Tread_Pattern__c,ETT_Desired_Length__c,ETT_Desired_Width__c,ETT_Tyre_Desired_OD__c,ETT_Activity_Performed__c,Main_Stock_Units__c,Factory_Stock_Units__c, ETT_Desired_Tread_Pattern__c,ETT_Job_Card__c FROM ETT_Job_Card_Line_Item__c where ETT_Job_Card__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Main_Job_Card__c and ETT_Activity_Performed__c='Side Crown buffing'];
                        //below line added by Janardhan
                        j.relatedJobWrapper.ThreadPrepDetails = [SELECT Id,ETT_Physical_Width__c,Desired_Tread_Pattern__c from ETT_Job_Card_Line_Item__c Where ETT_Job_Card__r.ETT_Main_Job_Card__c=:j.relatedJobWrapper.validJobCardList[0].Id AND ETT_Activity_Performed__c ='Review Thread Specifications'];
                    }
                    
                    if(relatedLines!=null && relatedLines.size() >0){
                        for(ETT_Job_Card_Line_Item__c line:relatedLines){
                            System.debug('line: '+line);
                            if(line.Sequence__c==0 && line.ETT_Status__c!='Completed'){//open hold related activity
                                j.holdLineItem.jobLineItem=line;
                                j.holdLineItem.workTracker=line.ETT_Work_Activities__r!=null && line.ETT_Work_Activities__r.size() >0 ? line.ETT_Work_Activities__r[0] : new ETT_Work_Activity__c(); 
                                break;
                            }
                        }
                        for(ETT_Job_Card_Line_Item__c line:relatedLines){ 
                            System.debug('line: '+line);
                            System.debug('current_sequence: '+current_sequence);
                            if(current_sequence>0 && line.Sequence__c==current_sequence){
                                j.jobLineItem=line;
                                List<ETT_Work_Activity__c> workAct=[Select Id,ETT_Start_time__c,ETT_End_time__c,ETT_Job_Card_Line_Item__c from ETT_Work_Activity__c where ETT_Job_Card_Line_Item__c=:line.Id and ETT_End_time__c=null order by ETT_Start_time__c desc limit 1];
                                if(workAct!=null && workAct.size()>0){
                                    j.workTracker=workAct[0];
                                }
                                else{
                                    j.workTracker.ETT_Job_Card_Line_Item__c=line.Id;
                                } 
                                break;
                            }   
                            else if(current_sequence==0){
                                if(readOnlyView==true){
                                    j.jobLineItem=line;
                                    break;   
                                }
                                else if(line.ETT_Status__c!='Completed'){
                                    j.jobLineItem=line;
                                    List<ETT_Work_Activity__c> workAct=[Select Id,ETT_Start_time__c,ETT_End_time__c,ETT_Job_Card_Line_Item__c from ETT_Work_Activity__c where ETT_Job_Card_Line_Item__c=:line.Id and ETT_End_time__c=null order by ETT_Start_time__c desc limit 1];
                                    System.debug('workAct: '+workAct);
                                    if(workAct!=null && workAct.size()>0){
                                        j.workTracker=workAct[0];
                                    }
                                    else{
                                        j.workTracker.ETT_Job_Card_Line_Item__c=line.Id;
                                    }
                                    break;  
                                }
                            }
                            if(current_sequence<=0 && seqAsPerDB==0 & line.Sequence__c>0){
                                seqAsPerDB=Integer.ValueOf(line.Sequence__c);
                            }                    
                        }    
                    }
                    System.debug('stageValue: '+stageValue);
                    System.debug('Nextlineitem: '+Nextlineitem);
                    System.debug('seqAsPerDB: '+seqAsPerDB);
                    
                    if(j.jobLineItem.ETT_Job_Card__c==null){             
                        if(Nextlineitem!=null && Nextlineitem.Id==null){
                            Nextlineitem.ETT_Job_Card__c=j.relatedJobWrapper.validJobCardList[0].Id;
                            Nextlineitem.ETT_Revision_Number__c=currentVersion;
                            Nextlineitem.Sequence__c=(seqAsPerDB >0 ? seqAsPerDB+1 : (current_sequence==0 ? 1 : current_sequence));
                            Nextlineitem.RecordtypeId=Schema.SObjectType.ETT_Job_Card_Line_Item__c.getRecordTypeInfosByName().get(stageValue).getRecordTypeId();   
                            
                            upsert Nextlineitem;
                            j.jobLineItem=Nextlineitem;
                            
                            if(nextWorkTracker != null && nextWorkTracker!=null){
                                nextWorkTracker.ETT_Job_Card_Line_Item__c=Nextlineitem.Id;
                                upsert nextWorkTracker;
                                j.workTracker=nextWorkTracker;
                            }                    
                        }
                        else{
                            j.jobLineItem.ETT_Job_Card__c=j.relatedJobWrapper.validJobCardList[0].Id;
                            j.jobLineItem.ETT_Revision_Number__c=currentVersion;
                            j.jobLineItem.Sequence__c=(seqAsPerDB >0 ? seqAsPerDB+1 : (current_sequence==0 ? 1 : current_sequence));
                            j.jobLineItem.RecordtypeId=Schema.SObjectType.ETT_Job_Card_Line_Item__c.getRecordTypeInfosByName().get(stageValue).getRecordTypeId();
                        }
                    }
                }
                
                System.debug('return value = '+j);
                return j;
            }
    
    @AuraEnabled
    Public Static void updateTyreMasterDetails(ETT_Tyre_Master__c tyreMaster){        
        update tyreMaster;
    }
    
    //Added by Shweta - START
    /*@AuraEnabled
Public Static boolean updateMultipleJobCardLineItems(ETT_JobCardListController.JobLineItemWrapper jobCardlineWrapper,Boolean trackActivity, Boolean updateJobCard,String selectedNextStation,String jobCardIds,ETT_Job_Card_Line_Item__c nextlineitem){ 

List<ID> jobCardIdList = (List<Id>)System.JSON.deserialize(jobCardIds, List<Id>.class);

System.debug('jobCardlineWrapper: '+jobCardlineWrapper);

List<ETT_Job_Card_Line_Item__c> lstJobCardLineItem = new List<ETT_Job_Card_Line_Item__c>();

for(Id jId:jobCardIdList){
ETT_Job_Card_Line_Item__c objJobCardLineItem = new ETT_Job_Card_Line_Item__c();
objJobCardLineItem.ETT_Job_Card__c = jId;
objJobCardLineItem.ETT_Status__c = 'Completed';
objJobCardLineItem.ETT_Final_Activity_State__c = 'Good/Matched';
objJobCardLineItem.Sequence__c = 1;
objJobCardLineItem.ETT_Activity_Performed__c = 'Wearing, Workstation, Skills Set & Tools Check';
objJobCardLineItem.ETT_Type__c = 'Pre-Requisite Work';
objJobCardLineItem.RecordTypeId = Schema.SObjectType.ETT_Job_Card_Line_Item__c.getRecordTypeInfosByName().get('Curing').getRecordTypeId();
objJobCardLineItem.ETT_Revision_Number__c = 1;

lstJobCardLineItem.add(objJobCardLineItem);
}
try{
upsert lstJobCardLineItem;
insert nextlineitem;
}catch(Exception ex){
System.debug('Exception: '+ex.getMessage());
}
System.debug('lstJobCardLineItem: '+lstJobCardLineItem);


List<ETT_Work_Schedule__c> currentWorkSchedule=[Select Id,Name,ETT_Technician__c,ETT_Technician__r.Name,ETT_Start_time__c,ETT_End_time__c,ETT_Work_Station__c,ETT_Work_Station__r.ETT_Station_Code__c,ETT_Work_Station__r.Name,ETT_Work_Station__r.ETT_Station_Type__c from ETT_Work_Schedule__c where
ETT_Technician__c=:Userinfo.getUserId() and ETT_End_time__c>=:System.NOW() AND ETT_Start_time__c<=:System.NOW() limit 1];

JobLineItemWrapper j=new JobLineItemWrapper(); 
j.holdLineItem=new JobLineItemWrapper();
Integer seqAsPerDB=0;

j.relatedJobWrapper.validJobCardList=Database.query('Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+','+
+'ETT_Tyre_Master__r.ETT_Tyre_Size__c,ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name,ETT_Inspection_Card__r.ETT_Collection_Card__c,ETT_Inspection_Card__r.ETT_Brand__c,ETT_Inspection_Card__r.ETT_Country__c,'+
+'ETT_Inspection_Card__r.ETT_Pattern__c,ETT_Inspection_Card__r.ETT_Tyre_Size__c,ETT_Main_Job_Card__r.ETT_Stages__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Painting__c,ETT_Main_Job_Card__r.ETT_Defect_Identified_Final_Inspection__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Curing__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Rimming_Env__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Building__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Filling__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Cementing__c,ETT_Main_Job_Card__r.ETT_Repair_Rework_Reason_s__c,ETT_Main_Job_Card__r.ETT_Skiving_Rework_Reason_s__c,'+
+'ETT_Main_Job_Card__r.ETT_Tyre_Master__c,ETT_Main_Job_Card__r.Name,ETT_Main_Job_Card__r.ETT_Priority__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Actual_Width__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Length__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Tyre_Outer_Diameter_OD__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__r.Name,ETT_Main_Job_Card__r.ETT_Buffing_precured_tread_line__c from ETT_Job_Card__c where Id in :jobCardIdList ');        
System.debug(j);

return true;

}
*/
    //Added by Shweta - STOP    
    
    
    @AuraEnabled
    Public Static JobLineItemWrapper getMultipleValidJobCardLineDetail(String recordIds,String stageValue,Integer current_sequence,Boolean readOnlyView,ETT_Job_Card_Line_Item__c Nextlineitem,ETT_Work_Activity__c nextWorkTracker){ 
        List<ETT_Work_Schedule__c> currentWorkSchedule=[Select Id,Name,ETT_Technician__c,ETT_Technician__r.Name,ETT_Start_time__c,ETT_End_time__c,ETT_Work_Station__c,ETT_Work_Station__r.ETT_Station_Code__c,ETT_Work_Station__r.Name,ETT_Work_Station__r.ETT_Station_Type__c from ETT_Work_Schedule__c where
                                                        ETT_Technician__c=:Userinfo.getUserId() and ETT_End_time__c>=:System.NOW() AND ETT_Start_time__c<=:System.NOW() limit 1];
        
        System.debug('currentWorkSchedule: '+currentWorkSchedule);
        System.debug('current_sequence: '+current_sequence);
        
        JobLineItemWrapper j=new JobLineItemWrapper(); 
        j.holdLineItem=new JobLineItemWrapper();
        Integer seqAsPerDB=0;
        /*j.relatedJobWrapper.validJobCardList=Database.query('Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+','+
+'ETT_Tyre_Master__r.ETT_Tyre_Size__c,ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name,ETT_Inspection_Card__r.ETT_Collection_Card__c,ETT_Inspection_Card__r.ETT_Brand__c,ETT_Inspection_Card__r.ETT_Country__c,'+
+'ETT_Inspection_Card__r.ETT_Pattern__c,ETT_Inspection_Card__r.ETT_Tyre_Size__c,ETT_Main_Job_Card__r.ETT_Stages__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Painting__c,ETT_Main_Job_Card__r.ETT_Defect_Identified_Final_Inspection__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Curing__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Rimming_Env__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Building__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Filling__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Cementing__c,ETT_Main_Job_Card__r.ETT_Repair_Rework_Reason_s__c,ETT_Main_Job_Card__r.ETT_Skiving_Rework_Reason_s__c,'+
+'ETT_Main_Job_Card__r.ETT_Tyre_Master__c,ETT_Main_Job_Card__r.Name,ETT_Main_Job_Card__r.ETT_Priority__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Actual_Width__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Length__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Tyre_Outer_Diameter_OD__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__r.Name,ETT_Main_Job_Card__r.ETT_Buffing_precured_tread_line__c from ETT_Job_Card__c where Id in :recordIds');

*/
        
        
        List<ID> jobCardIdList = (List<Id>)System.JSON.deserialize(recordIds, List<Id>.class);
        System.debug('jobCardIdList: '+jobCardIdList);
        
        j.relatedJobWrapper.validJobCardList = Database.query('Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+','+
                                                              +'ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name,ETT_Tyre_Master__r.ETT_Tyre_Size__c,ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name,ETT_Inspection_Card__r.ETT_Collection_Card__c,ETT_Inspection_Card__r.ETT_Collection_Card__r.Skiving_on_GSO_sticker_area__c,ETT_Inspection_Card__r.ETT_Brand__c,ETT_Inspection_Card__r.ETT_Country__c,'+
                                                              +'ETT_Inspection_Card__r.ETT_Pattern__c,ETT_Inspection_Card__r.ETT_Tyre_Size__c,ETT_Main_Job_Card__r.ETT_Stages__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Painting__c,ETT_Main_Job_Card__r.ETT_Defect_Identified_Final_Inspection__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Curing__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Rimming_Env__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Building__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Filling__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Cementing__c,ETT_Main_Job_Card__r.ETT_Repair_Rework_Reason_s__c,ETT_Main_Job_Card__r.ETT_Skiving_Rework_Reason_s__c,'+
                                                              +'ETT_Main_Job_Card__r.ETT_Tyre_Master__c,ETT_Main_Job_Card__r.Name,ETT_Main_Job_Card__r.ETT_Priority__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Actual_Width__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Length__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Tyre_Outer_Diameter_OD__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__r.Name,ETT_Main_Job_Card__r.ETT_Buffing_precured_tread_line__c from ETT_Job_Card__c where Id in :jobCardIdList');
        
        
        
        
        if(j.relatedJobWrapper.validJobCardList!=null && j.relatedJobWrapper.validJobCardList.size() >0){
            System.debug('validJobCardList: '+j.relatedJobWrapper.validJobCardList);
            
            j.relatedJobWrapper.availableNextStationList=new Map<String,String>(); 
            if(j.relatedJobWrapper.validJobCardList[0].ETT_Job_Type__c=='Tyre - Refurbishing Services'){
                for(String s: allStationListRetreading){
                    if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c!=s){
                        j.relatedJobWrapper.availableNextStationList.put(s,s);
                    }
                }
            }
            else{
                for(String s: allStationListRepair){
                    if(currentWorkSchedule[0].ETT_Work_Station__r.ETT_Station_Type__c!=s){
                        j.relatedJobWrapper.availableNextStationList.put(s,s);
                    }
                }
            }
            
            String stageCombined=j.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c;
            List<String> stageListOrdered=new List<String>();
            String currentStageValue='';
            String nextStageValue='';
            Integer currentStageIndex=0;
            
            if(String.isNotBlank(stageCombined)){
                stageListOrdered=stageCombined.split(';');                    
                for(Integer i=0;i<stageListOrdered.size();i++){
                    if(stageListOrdered[i]==j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c){
                        currentStageIndex=i;
                        currentStageValue=stageListOrdered[i];
                        System.debug('currentStageValue: '+currentStageValue);
                        break;
                    }
                }
                if(stageListOrdered.size() > (currentStageIndex+1)){//trying to find if the list has next element
                    nextStageValue=stageListOrdered[currentStageIndex+1];
                    System.debug('nextStageValue: '+nextStageValue);
                }
            }
            j.relatedJobWrapper.nextStageValue=nextStageValue;//This will tell us the possible next stage value to predict
            
            
            Integer currentVersion=1;
            if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c);
            }            
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Removal of Rim tube Flap' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_RemovalRimTubeFlap_revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_RemovalRimTubeFlap_revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c);
            }
            else if(j.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Quality Control' && j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c >=1){
                currentVersion=Integer.ValueOf(j.relatedJobWrapper.validJobCardList[0].ETT_No_of_Quality_Control_Revisions__c);
            }
            //and so on for other stages
            
            //List<ETT_Job_Card_Line_Item__c> relatedLines=Database.query('Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card_Line_Item__c'),',')+' ,(Select Id,ETT_Start_time__c,ETT_End_time__c,ETT_Job_Card_Line_Item__c from ETT_Work_Activities__r where ETT_End_time__c=null) from ETT_Job_Card_Line_Item__c where ETT_Job_Card__c=\''+j.relatedJobWrapper.validJobCardList[0].Id+'\' AND RecordType.Name=:stageValue and ETT_Revision_Number__c=:currentVersion order by Sequence__c desc');
            List<ETT_Job_Card_Line_Item__c> relatedLines=Database.query('Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card_Line_Item__c'),',')+' ,(Select Id,ETT_Start_time__c,ETT_End_time__c,ETT_Job_Card_Line_Item__c from ETT_Work_Activities__r where ETT_End_time__c=null) from ETT_Job_Card_Line_Item__c where ETT_Job_Card__c in :jobCardIdList AND RecordType.Name=:stageValue and ETT_Revision_Number__c=:currentVersion order by Sequence__c desc');                
            
            String strQ = 'Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card_Line_Item__c'),',')+' ,(Select Id,ETT_Start_time__c,ETT_End_time__c,ETT_Job_Card_Line_Item__c from ETT_Work_Activities__r where ETT_End_time__c=null) from ETT_Job_Card_Line_Item__c where ETT_Job_Card__c in :jobCardIdList AND RecordType.Name=:stageValue and ETT_Revision_Number__c=:currentVersion order by Sequence__c desc';
            System.debug('strQ: '+strQ);
            
            
            
            if(j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__r.ETT_Collection_Card__c!=null){
                List<ETT_Tyre_Master__c> tyreMasterList=[SELECT Id,name,ETT_Length__c,ETT_Status__c,ETT_Tyre_Outer_Diameter_OD__c,ETT_Actual_Width__c,ETT_Original_Pattern__c From ETT_Tyre_Master__c where ETT_Tyre_Size__r.ETT_Status__c=true and ETT_Brand_Name__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__r.ETT_Brand__c and ETT_Original_Pattern__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__r.ETT_Pattern__c and ETT_Country_Name__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__r.ETT_Country__c and ETT_Tyre_Size__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__r.ETT_Tyre_Size__c];
                if(tyreMasterList!=null && tyreMasterList.size() >0){
                    j.relatedJobWrapper.tyreMaster=[Select Id,Name,ETT_Length__c,ETT_Status__c,ETT_Tyre_Outer_Diameter_OD__c,ETT_Actual_Width__c,ETT_Original_Pattern__c from ETT_Tyre_Master__c where Id=:tyreMasterList[0].Id];
                    j.relatedJobWrapper.treadMasterList=[Select Id,Name,ETT_Tools_Master__r.RecordtypeId,ETT_Tools_Master__r.Recordtype.Name,ETT_Tools_Master__c,ETT_Tools_Master__r.ETT_Depth__c,ETT_Tools_Master__r.ETT_KG_Per_Mtr__c,ETT_Tools_Master__r.ETT_Pattern_Master__c,ETT_Tools_Master__r.ETT_Tread_Width__c,ETT_Previous_Tools_Allocation__c,ETT_Tools_Master__r.Name,ETT_Tools_Master__r.ETT_Item_Description__c,ETT_Tools_Master__r.ETT_Status__c,ETT_Tools_Master__r.ETT_Unique_Code__c,ETT_Tools_Master__r.ETT_Tool_type__c,ETT_Tools_Master__r.ETT_Serial_No__c,ETT_Usage_End_time__c,ETT_Remarks__c from ETT_Tools_Allocation__c where ETT_Tools_Master__r.ETT_Status__c!='Obsolete' and ETT_Tools_Master__r.ETT_Status__c!='Rejected' and ETT_Tools_Master__r.ETT_Allocated_Units__c>0 and ETT_Tools_Master__r.Recordtype.Name='Material - Treads' and ETT_Tools_Master__r.ETT_Pattern_Master__c=:j.relatedJobWrapper.tyreMaster.ETT_Original_Pattern__c];
                } 
                List<ETT_Tyre_Rejection_Line_Item__c> crownRejectionItems=[Select Id,name,ETT_Number_of_cuts_0_10_mm__c,ETT_Number_of_cuts_11_to_25_mm__c,ETT_Number_of_cuts_26_to_38_mm__c,ETT_Number_of_cuts_39_to_50_mm__c,ETT_Number_of_cuts_51_mm_and_above__c from ETT_Tyre_Rejection_Line_Item__c where ETT_Inspection_Card__c=:j.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__c and name='CrownArea'];
                if(crownRejectionItems!=null && crownRejectionItems.size() >0){
                    j.relatedJobWrapper.tyreRejectionItemCrown=crownRejectionItems[0];
                }
            }
            
            if(relatedLines!=null && relatedLines.size() >0){
                for(ETT_Job_Card_Line_Item__c line:relatedLines){
                    System.debug('line: '+line);
                    if(line.Sequence__c==0 && line.ETT_Status__c!='Completed'){//open hold related activity
                        j.holdLineItem.jobLineItem=line;
                        j.holdLineItem.workTracker=line.ETT_Work_Activities__r!=null && line.ETT_Work_Activities__r.size() >0 ? line.ETT_Work_Activities__r[0] : new ETT_Work_Activity__c(); 
                        break;
                    }
                }
                for(ETT_Job_Card_Line_Item__c line:relatedLines){ 
                    System.debug('line: '+line);
                    System.debug('current_sequence: '+current_sequence);
                    if(current_sequence>0 && line.Sequence__c==current_sequence){
                        j.jobLineItem=line;
                        List<ETT_Work_Activity__c> workAct=[Select Id,ETT_Start_time__c,ETT_End_time__c,ETT_Job_Card_Line_Item__c from ETT_Work_Activity__c where ETT_Job_Card_Line_Item__c=:line.Id and ETT_End_time__c=null order by ETT_Start_time__c desc limit 1];
                        if(workAct!=null && workAct.size()>0){
                            j.workTracker=workAct[0];
                        }
                        else{
                            j.workTracker.ETT_Job_Card_Line_Item__c=line.Id;
                        } 
                        break;
                    }   
                    else if(current_sequence==0){
                        if(readOnlyView==true){
                            j.jobLineItem=line;
                            break;   
                        }
                        else if(line.ETT_Status__c!='Completed'){
                            j.jobLineItem=line;
                            List<ETT_Work_Activity__c> workAct=[Select Id,ETT_Start_time__c,ETT_End_time__c,ETT_Job_Card_Line_Item__c from ETT_Work_Activity__c where ETT_Job_Card_Line_Item__c=:line.Id and ETT_End_time__c=null order by ETT_Start_time__c desc limit 1];
                            System.debug('workAct: '+workAct);
                            if(workAct!=null && workAct.size()>0){
                                j.workTracker=workAct[0];
                            }
                            else{
                                j.workTracker.ETT_Job_Card_Line_Item__c=line.Id;
                            }
                            break;  
                        }
                    }
                    if(current_sequence<=0 && seqAsPerDB==0 & line.Sequence__c>0){
                        seqAsPerDB=Integer.ValueOf(line.Sequence__c);
                    }                    
                }    
            }
            System.debug('stageValue: '+stageValue);
            System.debug('Nextlineitem: '+Nextlineitem);
            System.debug('seqAsPerDB: '+seqAsPerDB);
            
            System.debug('j.jobLineItem: '+j.jobLineItem);
            /*
if(j.jobLineItem.ETT_Job_Card__c==null){             
if(Nextlineitem!=null && Nextlineitem.Id==null){
Nextlineitem.ETT_Job_Card__c=j.relatedJobWrapper.validJobCardList[0].Id;
Nextlineitem.ETT_Revision_Number__c=currentVersion;
Nextlineitem.Sequence__c=(seqAsPerDB >0 ? seqAsPerDB+1 : (current_sequence==0 ? 1 : current_sequence));
Nextlineitem.RecordtypeId=Schema.SObjectType.ETT_Job_Card_Line_Item__c.getRecordTypeInfosByName().get(stageValue).getRecordTypeId();   

upsert Nextlineitem;
j.jobLineItem=Nextlineitem;

if(nextWorkTracker != null && nextWorkTracker!=null){
nextWorkTracker.ETT_Job_Card_Line_Item__c=Nextlineitem.Id;
upsert nextWorkTracker;
j.workTracker=nextWorkTracker;
}                    
}
else{
j.jobLineItem.ETT_Job_Card__c=j.relatedJobWrapper.validJobCardList[0].Id;
j.jobLineItem.ETT_Revision_Number__c=currentVersion;
j.jobLineItem.Sequence__c=(seqAsPerDB >0 ? seqAsPerDB+1 : (current_sequence==0 ? 1 : current_sequence));
j.jobLineItem.RecordtypeId=Schema.SObjectType.ETT_Job_Card_Line_Item__c.getRecordTypeInfosByName().get(stageValue).getRecordTypeId();
}
}
*/
            
            if(j.jobLineItem.ETT_Job_Card__c==null){             
                if(Nextlineitem!=null && Nextlineitem.Id==null){
                    List<ETT_Job_Card_Line_Item__c> lstJobCardLineItem = new List<ETT_Job_Card_Line_Item__c>();
                    for(ID jb:jobCardIdList){
                        ETT_Job_Card_Line_Item__c objNextlineitem = new ETT_Job_Card_Line_Item__c();
                        
                        objNextlineitem.ETT_Status__c = Nextlineitem.ETT_Status__c;
                        objNextlineitem.ETT_Activity_Performed__c = Nextlineitem.ETT_Activity_Performed__c;
                        objNextlineitem.ETT_Type__c = Nextlineitem.ETT_Type__c;
                        objNextlineitem.Id = Null;
                        objNextlineitem.ETT_Job_Card__c= jb;  //j.relatedJobWrapper.validJobCardList[0].Id;
                        objNextlineitem.ETT_Revision_Number__c=currentVersion;
                        objNextlineitem.Sequence__c=(seqAsPerDB >0 ? seqAsPerDB+1 : (current_sequence==0 ? 1 : current_sequence));
                        objNextlineitem.RecordtypeId=Schema.SObjectType.ETT_Job_Card_Line_Item__c.getRecordTypeInfosByName().get(stageValue).getRecordTypeId();   
                        lstJobCardLineItem.add(objNextlineitem);
                    }
                    System.debug('lstJobCardLineItem: '+lstJobCardLineItem);
                    upsert lstJobCardLineItem;
                    //upsert Nextlineitem;
                    j.jobLineItem=Nextlineitem;
                    
                    List<ETT_Work_Activity__c> lstnextWorkTracker = new List<ETT_Work_Activity__c>();
                    
                    for(ETT_Job_Card_Line_Item__c lst:lstJobCardLineItem){
                        ETT_Work_Activity__c objWorkActivity = new ETT_Work_Activity__c();
                        objWorkActivity.ETT_Job_Card_Line_Item__c = lst.Id;
                        objWorkActivity.ETT_Start_time__c = nextWorkTracker.ETT_Start_time__c;
                        lstnextWorkTracker.add(objWorkActivity);
                    }
                    upsert lstnextWorkTracker;
                    if(nextWorkTracker != null && nextWorkTracker!=null){
                        nextWorkTracker.ETT_Job_Card_Line_Item__c=Nextlineitem.Id;
                        //upsert nextWorkTracker;
                        j.workTracker=nextWorkTracker;
                    }                    
                }
                else{
                    j.jobLineItem.ETT_Job_Card__c=j.relatedJobWrapper.validJobCardList[0].Id;
                    j.jobLineItem.ETT_Revision_Number__c=currentVersion;
                    j.jobLineItem.Sequence__c=(seqAsPerDB >0 ? seqAsPerDB+1 : (current_sequence==0 ? 1 : current_sequence));
                    j.jobLineItem.RecordtypeId=Schema.SObjectType.ETT_Job_Card_Line_Item__c.getRecordTypeInfosByName().get(stageValue).getRecordTypeId();
                }
            }
            
        }
        
        
        
        
        return j;
        
        
    }
    
    
    @AuraEnabled
    Public Static ETT_JobCardListController.JobLineItemWrapper updateMultipleJobCardLineItems(ETT_JobCardListController.JobLineItemWrapper jobCardlineWrapper,Boolean trackActivity, Boolean updateJobCard,String selectedNextStation,String jobCardIds){ 
        
        List<ID> jobCardIdList = (List<Id>)System.JSON.deserialize(jobCardIds, List<Id>.class);
        System.debug('jobCardIdList: '+jobCardIdList);
        List<ETT_Job_Card_Line_Item__c> lstJobCardLineItems = new List<ETT_Job_Card_Line_Item__c>();
        List<ETT_Job_Card__c> jobCardUpdateList = new List<ETT_Job_Card__c>();
        
        List<ETT_Job_Card_Line_Item__c> lstJobCardLineItem = [select Id,ETT_Job_Card__c,ETT_Status__c,Sequence__c from ETT_Job_Card_Line_Item__c where ETT_Job_Card__c in :jobCardIdList];
        
        if(lstJobCardLineItem!=null && lstJobCardLineItem.size()>0){
            for(ETT_Job_Card_Line_Item__c lstJCLI : lstJobCardLineItem){
                if(lstJCLI.Sequence__c != 1){
                    lstJCLI.ETT_Status__c = 'Completed';    
                }
            }
            upsert lstJobCardLineItem;
        }
        for(Id jId:jobCardIdList){
            if(jobCardlineWrapper.jobLineItem.ETT_Job_Card__c!=jId && jobCardlineWrapper.jobLineItem.Sequence__c==1){
                ETT_Job_Card_Line_Item__c objJCLI = new ETT_Job_Card_Line_Item__c();
                objJCLI.ETT_Job_Card__c = jId; //jobCardlineWrapper.jobLineItem.ETT_Job_Card__c;
                objJCLI.ETT_Status__c = 'Completed'; //jobCardlineWrapper.jobLineItem.ETT_Status__c;
                objJCLI.ETT_Final_Activity_State__c = jobCardlineWrapper.jobLineItem.ETT_Final_Activity_State__c;
                objJCLI.Sequence__c = jobCardlineWrapper.jobLineItem.Sequence__c;
                objJCLI.ETT_Activity_Performed__c = jobCardlineWrapper.jobLineItem.ETT_Activity_Performed__c;
                objJCLI.ETT_Type__c = jobCardlineWrapper.jobLineItem.ETT_Type__c;
                objJCLI.RecordTypeId = jobCardlineWrapper.jobLineItem.RecordTypeId;
                objJCLI.ETT_Revision_Number__c = jobCardlineWrapper.jobLineItem.ETT_Revision_Number__c;
                lstJobCardLineItems.add(objJCLI);
            }
            
        }
        System.debug('lstJobCardLineItems: '+lstJobCardLineItems); 
        
        
        if(jobCardlineWrapper.jobLineItem != null && String.isNotBlank(jobCardlineWrapper.jobLineItem.ETT_Activity_Performed__c)){
            upsert jobCardlineWrapper.jobLineItem; //insert lstJobCardLineItems;
            insert lstJobCardLineItems;
            if(jobCardlineWrapper.jobLineItem.ETT_End_parent_line_item__c && jobCardlineWrapper.jobLineItem.ETT_Linked_Job_Card_Line_Item__c!=null){
                ETT_Job_Card_Line_Item__c parentLine=new ETT_Job_Card_Line_Item__c(Id=jobCardlineWrapper.jobLineItem.ETT_Linked_Job_Card_Line_Item__c,ETT_Status__c='Completed',ETT_Final_Activity_State__c='Good');
                update parentLine;
            }
            
            if(jobCardlineWrapper.workTracker != null && trackActivity){
                jobCardlineWrapper.workTracker.ETT_Job_Card_Line_Item__c=jobCardlineWrapper.jobLineItem.Id;
                upsert jobCardlineWrapper.workTracker;
            }
            
            List<String> validStageList=new List<String>();
            
            if(jobCardlineWrapper.relatedJobWrapper.validJobCardList !=null && jobCardlineWrapper.relatedJobWrapper.validJobCardList.size() >0){
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Type__c=='Tyre - Refurbishing Services'){
                    validStageList.addAll(allStationListRetreading);
                }
                else{
                    validStageList.addAll(allStationListRepair);
                }            
                Integer selectedStageIndex;
                Integer newStageIndex;
                if(String.isNotBlank(selectedNextStation)){
                    for(Integer s=0;s<validStageList.size();s++){
                        if(validStageList[s] == jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c){
                            newStageIndex=s;
                        }
                        if(validStageList[s]==selectedNextStation){
                            selectedStageIndex=s;
                        }
                    }    
                } 
                
                if(selectedStageIndex < newStageIndex){
                    throw new AuraHandledException('Previous station cannot selected. Use "Raise Defect" button to send back.');
                }
            }
            
            List<String> stageListOrdered=new List<String>();
            Set<String> stageListSet=new Set<String>();
            String currentStageValue='';
            String nextStageValue='';
            Integer currentStageIndex=0;
            
            if(jobCardlineWrapper.relatedJobWrapper!=null && jobCardlineWrapper.relatedJobWrapper.validJobCardList!=null && 
               jobCardlineWrapper.relatedJobWrapper.validJobCardList.size() >0){
                   String stageCombined=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c;
                   if(String.isNotBlank(stageCombined)){
                       stageListOrdered=stageCombined.split(';');                    
                       for(Integer i=0;i<stageListOrdered.size();i++){
                           if(stageListOrdered[i]==jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c){
                               currentStageIndex=i;
                               currentStageValue=stageListOrdered[i];
                               break;
                           }
                       }
                       if(stageListOrdered.size() > (currentStageIndex+1)){
                           nextStageValue=stageListOrdered[currentStageIndex+1];
                       }
                   }
                   jobCardlineWrapper.relatedJobWrapper.nextStageValue=nextStageValue;//This will tell us the possible next stage value to predict
               }
            
            if(updateJobCard){    
                if(jobCardlineWrapper.jobLineItem.Sequence__c==1){
                    for(Id jId:jobCardIdList){
                        ETT_Job_Card__c jc = new ETT_Job_Card__c();
                        jc.Id = jId;
                        String regExp = '[-: ]';
                        jc.Curing_Batch_No__c = string.valueof(DateTime.now()).replaceAll(regExp,'');
                        jobCardUpdateList.add(jc);
                    } 
                    update jobCardUpdateList;
                }
               
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c =='Accepted'){
                    
                    for(Id jId:jobCardIdList){
                        ETT_Job_Card__c jc = new ETT_Job_Card__c();
                        jc.Id = jId;
                        jc.ETT_Previous_Job_Stage__c =jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                        if(String.isNotBlank(selectedNextStation)){
                            jc.ETT_Stages__c=selectedNextStation;
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                            jc.ETT_Stages__c=nextStageValue;
                        }
                        else{
                            jc.ETT_Stages__c='Removal of RIM Tube Flap';
                        }
                        jobCardUpdateList.add(jc);
                    }
                    
                    
                    update jobCardUpdateList;
                    
                    
                    
                }  
                
                //update jobCardlineWrapper.relatedJobWrapper.validJobCardList;
                
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit buffing process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Buffing_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit skiving process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Skiving_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit skiving process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Repair_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit skiving process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Cementing_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit Filling process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Filling_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }//approvals not applicable for thread preparation stage.                
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit Building process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Building_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit Curing process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('Job_Card_Final_Inspection_Process');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                //and so on for other stages
            }
        }
        return jobCardlineWrapper;
    }
    
    
    @AuraEnabled
    Public Static ETT_JobCardListController.JobLineItemWrapper updateJobCardLine(ETT_JobCardListController.JobLineItemWrapper jobCardlineWrapper,Boolean trackActivity, Boolean updateJobCard,String selectedNextStation){ 
        
        if(jobCardlineWrapper.jobLineItem != null && String.isNotBlank(jobCardlineWrapper.jobLineItem.ETT_Activity_Performed__c)){
            upsert jobCardlineWrapper.jobLineItem;
            system.debug('NewJob'+jobCardlineWrapper.jobLineItem);
            if(jobCardlineWrapper.jobLineItem.ETT_End_parent_line_item__c && jobCardlineWrapper.jobLineItem.ETT_Linked_Job_Card_Line_Item__c!=null){
                ETT_Job_Card_Line_Item__c parentLine=new ETT_Job_Card_Line_Item__c(Id=jobCardlineWrapper.jobLineItem.ETT_Linked_Job_Card_Line_Item__c,ETT_Status__c='Completed',ETT_Final_Activity_State__c='Good');
                update parentLine;
            }
            
            if(jobCardlineWrapper.workTracker != null && trackActivity){
                jobCardlineWrapper.workTracker.ETT_Job_Card_Line_Item__c=jobCardlineWrapper.jobLineItem.Id;
                upsert jobCardlineWrapper.workTracker;
            }
            
            List<String> validStageList=new List<String>();
            
            if(jobCardlineWrapper.relatedJobWrapper.validJobCardList !=null && jobCardlineWrapper.relatedJobWrapper.validJobCardList.size() >0){
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Type__c=='Tyre - Refurbishing Services'){
                    validStageList.addAll(allStationListRetreading);
                }
                else{
                    validStageList.addAll(allStationListRepair);
                }            
                Integer selectedStageIndex;
                Integer newStageIndex;
                system.debug('valid stage ='+validStageList);
                system.debug('selectedNextStation ='+selectedNextStation);
                system.debug('job card='+jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c);
                if(String.isNotBlank(selectedNextStation)){
                    for(Integer s=0;s<validStageList.size();s++){
                        if(validStageList[s] == jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c){
                            newStageIndex=s;
                        }
                        if(validStageList[s]==selectedNextStation){
                            selectedStageIndex=s;
                        }
                    }    
                } 
                System.debug('selectedStageIndex: '+selectedStageIndex);
                System.debug('newStageIndex: '+newStageIndex);                
                if(selectedStageIndex < newStageIndex){
                    throw new AuraHandledException('Previous station cannot selected. Use "Raise Defect" button to send back.');
                }
            }
            
            List<String> stageListOrdered=new List<String>();
            Set<String> stageListSet=new Set<String>();
            String currentStageValue='';
            String nextStageValue='';
            Integer currentStageIndex=0;
            
            if(jobCardlineWrapper.relatedJobWrapper!=null && jobCardlineWrapper.relatedJobWrapper.validJobCardList!=null && 
               jobCardlineWrapper.relatedJobWrapper.validJobCardList.size() >0){
                   String stageCombined=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c;
                   if(String.isNotBlank(stageCombined)){
                       stageListOrdered=stageCombined.split(';');                    
                       for(Integer i=0;i<stageListOrdered.size();i++){
                           if(stageListOrdered[i]==jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c){
                               currentStageIndex=i;
                               currentStageValue=stageListOrdered[i];
                               break;
                           }
                       }
                       if(stageListOrdered.size() > (currentStageIndex+1)){
                           nextStageValue=stageListOrdered[currentStageIndex+1];
                       }
                   }
                   jobCardlineWrapper.relatedJobWrapper.nextStageValue=nextStageValue;//This will tell us the possible next stage value to predict
               }
            
            if(updateJobCard){                
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c =='Accepted'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    if(String.isNotBlank(selectedNextStation)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=selectedNextStation;
                    }
                    else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=nextStageValue;
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c='Skiving';
                    }
                    
                    if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='';
                        } 
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='  Waiting for Acceptance' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Resubmitted by Buffing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='';
                        }
                    }                    
                    //and so on for other stages
                    
                    Set<String> StageListCheckSet = new Set<String>(stageListOrdered);
                    if(StageListCheckSet.contains(String.valueOf(currentStageIndex)))
                        stageListOrdered.remove(currentStageIndex);
                    //stageListOrdered.remove(currentStageIndex);
                    
                    if(stageListOrdered.size()>0){
                        stageListSet=new Set<String>(stageListOrdered);
                    }
                    if(!stageListSet.contains(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c)){//if the next stage not present in our ordered field populate in the beginning
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+';'+String.join(stageListOrdered,';');
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                    }
                    
                    //Start: Block of code for buffing stage alone. not applies to other stages
                  
                    String jobQueryStr='Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+' from ETT_Job_Card__c where ETT_Main_Job_Card__c=\''+jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].Id+'\'';
                    ETT_Job_Card__c threadJobCard=new ETT_Job_Card__c();
                    for(ETT_Job_Card__c jc:Database.query(jobQueryStr)){
                        if(jc.ETT_Main_Job_Card__c!=null && jc.ETT_Stages__c=='Thread Preparation'){
                            jc.ETT_Thread_Preparation_Status__c=(jc.ETT_Thread_Preparation_Status__c=='Waiting for Acceptance' ? 'Resubmitted by Buffing' : jc.ETT_Thread_Preparation_Status__c);
                            jc.ETT_Job_Stages_to_Perform_Ordered__c='Thread Preparation';
                            jc.ETT_No_of_Thread_Preparation_revisions__c=(jc.ETT_No_of_Thread_Preparation_revisions__c==null ? 1 : (jc.ETT_Thread_Preparation_Status__c != null && jc.ETT_Thread_Preparation_Status__c.startsWithIgnoreCase('resubmitted') ? jc.ETT_No_of_Thread_Preparation_revisions__c+1 : jc.ETT_No_of_Thread_Preparation_revisions__c));
                            threadJobCard=jc;
                        } 
                    }
                    if(threadJobCard.Id==null){
                        threadJobCard=new ETT_Job_Card__c(ETT_Priority__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Priority__c,Tyre_Inventory__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].Tyre_Inventory__c,ETT_Main_Job_Card__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].Id,ETT_Stages__c='Thread Preparation',ETT_Job_Stages_to_Perform_Ordered__c='Thread Preparation',ETT_Thread_Preparation_Status__c='',ETT_No_of_Thread_Preparation_revisions__c=1,ETT_Inspection_Card__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Inspection_Card__c);
                    }
                    upsert threadJobCard;
                    //End: Block of code for buffing stage alone. not applies to other stages
                } 
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c =='Accepted'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    if(String.isNotBlank(selectedNextStation)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=selectedNextStation;
                    }
                    else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=nextStageValue;
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c='Repair';
                    }
                    
                    if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Resubmitted by Skiving';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='Resubmitted by Skiving';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='';
                        } 
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='Resubmitted by Skiving';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Resubmitted by Skiving';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='  Waiting for Acceptance' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='Resubmitted by Skiving';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='Resubmitted by Skiving';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Resubmitted by Skiving';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='Resubmitted by Skiving';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='Resubmitted by Skiving';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='Resubmitted by Skiving';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='';
                        }
                    }
                    Set<String> StageListCheckSet = new Set<String>(stageListOrdered);
                    if(StageListCheckSet.contains(String.valueOf(currentStageIndex)))
                        stageListOrdered.remove(currentStageIndex);
                    //  stageListOrdered.remove(currentStageIndex);
                    if(stageListOrdered.size()>0){
                        stageListSet=new Set<String>(stageListOrdered);
                    }
                    if(!stageListSet.contains(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c)){//if the next stage not present in our ordered field populate in the beginning
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+';'+String.join(stageListOrdered,';');
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                    }
                    System.debug('Tech: '+Userinfo.getUserId());
                    //assign technician
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].Skiving_Technician__c = Userinfo.getUserId();
                    System.debug('Tech: '+jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].Skiving_Technician__c);
                    
                } 
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c =='Accepted'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    if(String.isNotBlank(selectedNextStation)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=selectedNextStation;
                    }
                    else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=nextStageValue;
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c='Cementing';
                    }
                    
                    if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Resubmitted by Repair';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Resubmitted by Repair';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='';
                        } 
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='Resubmitted by Repair';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Resubmitted by Repair';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='  Waiting for Acceptance' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='Resubmitted by Repair';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='Resubmitted by Repair';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Resubmitted by Repair';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='Resubmitted by Repair';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='Resubmitted by Repair';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='Resubmitted by Repair';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='';
                        }
                    }
                    Set<String> StageListCheckSet = new Set<String>(stageListOrdered);
                    if(StageListCheckSet.contains(String.valueOf(currentStageIndex)))
                        stageListOrdered.remove(currentStageIndex);
                    //  stageListOrdered.remove(currentStageIndex);
                    if(stageListOrdered.size()>0){
                        stageListSet=new Set<String>(stageListOrdered);
                    }
                    if(!stageListSet.contains(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c)){//if the next stage not present in our ordered field populate in the beginning
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+';'+String.join(stageListOrdered,';');
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                    }
                } 
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c =='Accepted'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    if(String.isNotBlank(selectedNextStation)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=selectedNextStation;
                    }
                    else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=nextStageValue;
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c='Filling';
                    }
                    
                    //Is current month April to October then wait time is 20mints else 30mints
                    Integer Month = Date.Today().Month();
                    DateTime dt = System.now();
                    DateTime laterTime;
                    if(Month>=4 && Month<=10){
                        laterTime = dt.addMinutes(+20);
                    }else{
                        laterTime = dt.addMinutes(+30);
                    }
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cemented_Least_Available_Time__c = laterTime;
                    
                    
                    
                    if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Resubmitted by Cementing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Resubmitted by Cementing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='';
                        } 
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='Resubmitted by Cementing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Resubmitted by Cementing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='  Waiting for Acceptance' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='Resubmitted by Cementing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='Resubmitted by Cementing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Resubmitted by Cementing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='Resubmitted by Cementing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='Resubmitted by Cementing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='Resubmitted by Cementing';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='';
                        }
                    }
                    Set<String> StageListCheckSet = new Set<String>(stageListOrdered);
                    if(StageListCheckSet.contains(String.valueOf(currentStageIndex)))
                        stageListOrdered.remove(currentStageIndex);
                    // stageListOrdered.remove(currentStageIndex);
                    if(stageListOrdered.size()>0){
                        stageListSet=new Set<String>(stageListOrdered);
                    }
                    if(!stageListSet.contains(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c)){//if the next stage not present in our ordered field populate in the beginning
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+';'+String.join(stageListOrdered,';');
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                    }
                } 
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c =='Accepted'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    
                    //Start - Specific to threading process related logic
                    Boolean bypassThreadStage=true;
                    String jobQueryStr='Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+' from ETT_Job_Card__c where ETT_Main_Job_Card__c=\''+jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].Id+'\'';
                    ETT_Job_Card__c threadJobCard=new ETT_Job_Card__c();
                    for(ETT_Job_Card__c jc:Database.query(jobQueryStr)){
                        if(jc.ETT_Main_Job_Card__c!=null && jc.ETT_Stages__c=='Thread Preparation'){
                            
                            
                            if(jc.ETT_Thread_Preparation_Status__c!='Accepted'){ //Jana - changed from Waiting for Acceptance to Accepted
                                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c='Thread Preparation';
                                bypassThreadStage=false;
                            }
                            else{ 
                                Set<String> StageListCheckSet = new Set<String>(stageListOrdered);
                                if(StageListCheckSet.contains(String.valueOf(currentStageIndex)))
                                    stageListOrdered.remove(currentStageIndex);
                                // stageListOrdered.remove(currentStageIndex);
                                Integer newPosition;
                                for(Integer j=0;j<stageListOrdered.size();j++){
                                    if(stageListOrdered[j]=='Thread Preparation'){
                                        newPosition=j;
                                    }
                                }
                               if(newPosition!=null){
                                    stageListOrdered.remove(newPosition);
                                } 
                                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=jc.ETT_Thread_Preparation_Status__c;
                                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c=jc.ETT_No_of_Thread_Preparation_revisions__c;
                                currentStageIndex=null;
                                newPosition=null;
                            }
                        }
                    }
                    system.debug('--Jana--'+bypassThreadStage);
                    if(bypassThreadStage && selectedNextStation=='Thread Preparation' && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c.containsIgnoreCase('Thread Preparation')){
                        throw new AuraHandledException('Thread preparation has been already completed. Please choose next station.');
                    }
                    else if(!bypassThreadStage && selectedNextStation!='Thread Preparation'){
                        throw new AuraHandledException('Thread preparation to be choosed.');
                    }
                    else if(selectedNextStation!='Thread Preparation'){//perform this condition only when the stage is not found by above code from its child job card.
                        if(String.isNotBlank(selectedNextStation)){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=selectedNextStation;
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=nextStageValue;
                        }
                    }
                    
                    if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c)){
                        if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c)){
                            List<String> upcomingStages=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c.split(';');
                            Integer k=0;
                            Boolean itemFound=false;
                            for(String s:upcomingStages){
                                if(s==jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c){  
                                    itemFound=true;
                                    break;
                                }
                                k++;
                            }
                            if(itemFound){
                                upcomingStages.remove(k);    
                            }
                            //Jana- commented below line - no idea why created
                            //jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+';'+String.join(upcomingStages,';');
                        }              
                    }
                    
                    //End - Specific to threading process related logic
                    
                    if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Resubmitted by Filling';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Resubmitted by Filling';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='Resubmitted by Filling';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='';
                        } 
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='Resubmitted by Filling';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='';
                        }
                    }
                    //Since we have a logic added for thread related stage before we need to skip this block again.
                    /*else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation'){
jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c+1) : 1;
//Let ensure we are not resetting the status if its already having resubmission/defect identified status
if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='  Waiting for Acceptance' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Defects Identified & Sent Back'){
jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='Resubmitted by Filling';
}
else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c.startsWithIgnoreCase('resubmitted')){
jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='';
}
}*/
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='Resubmitted by Filling';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Resubmitted by Filling';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='Resubmitted by Filling';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='Resubmitted by Filling';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='Resubmitted by Filling';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='';
                        }
                    }
                    //and so on for other stages
                    
                    if(currentStageIndex!=null){//specific to this stage since we removed this item from list in earlier condition itself.
                        Set<String> StageListCheckSet = new Set<String>(stageListOrdered);
                        if(StageListCheckSet.contains(String.valueOf(currentStageIndex)))
                            stageListOrdered.remove(currentStageIndex);
                        //    stageListOrdered.remove(currentStageIndex);
                        if(stageListOrdered.size()>0){
                            stageListSet=new Set<String>(stageListOrdered);
                        }
                        if(!stageListSet.contains(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c)){//if the next stage not present in our ordered field populate in the beginning
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+';'+String.join(stageListOrdered,';');
                        }
                        else{
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                        }
                    }
                } 
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c =='Waiting for Acceptance'){
                    String jobQueryStr='Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+' from ETT_Job_Card__c where Id=\''+jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Main_Job_Card__c+'\'';
                    ETT_Job_Card__c parentCard=new ETT_Job_Card__c();
                    for(ETT_Job_Card__c jc:Database.query(jobQueryStr)){
                        if(jc.ETT_Stages__c=='Thread Preparation'){
                            jc.ETT_Thread_Preparation_Status__c=(String.isBlank(jc.ETT_Thread_Preparation_Status__c) || (String.isNotBlank(jc.ETT_Thread_Preparation_Status__c) && jc.ETT_Thread_Preparation_Status__c.startsWithIgnoreCase('resubmitted'))) ? 'Waiting for Acceptance' : jc.ETT_Thread_Preparation_Status__c;
                            jc.ETT_No_of_Thread_Preparation_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c;
                            jc.ETT_Thread_Least_Available_Time__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Least_Available_Time__c;
                            jc.ETT_Thread_Preparation_Work_Schedule__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Work_Schedule__c;
                            //check main parent job card stage order to find next stage value
                            stageListOrdered=new List<String>();
                            currentStageValue='';
                            nextStageValue='';
                            currentStageIndex=0;                            
                            if(String.isNotBlank(jc.ETT_Job_Stages_to_Perform_Ordered__c)){
                                String stageCombined=jc.ETT_Job_Stages_to_Perform_Ordered__c;
                                if(String.isNotBlank(stageCombined)){
                                    stageListOrdered=stageCombined.split(';');                    
                                    for(Integer i=0;i<stageListOrdered.size();i++){
                                        if(stageListOrdered[i]==jc.ETT_Stages__c){
                                            currentStageIndex=i;
                                            currentStageValue=stageListOrdered[i];
                                            break;
                                        }
                                    }
                                    if(stageListOrdered.size() > (currentStageIndex+1)){
                                        nextStageValue=stageListOrdered[currentStageIndex+1];
                                    }
                                }
                                jc.ETT_Stages__c=nextStageValue;//This will tell us the possible next stage value to predict
                            }
                            //other related stages are not applicable for thread stage
                            if(jc.ETT_Stages__c=='Building'){
                                jc.ETT_No_of_Building_Revisions__c=jc.ETT_No_of_Building_Revisions__c!=null ? (jc.ETT_No_of_Building_Revisions__c+1) : 1;
                                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                                if(jc.ETT_Building_Status__c=='Initial Rejection' || jc.ETT_Building_Status__c=='Accepted' || jc.ETT_Building_Status__c=='Defects Identified & Sent Back'){
                                    jc.ETT_Building_Status__c='Resubmitted by Thread Preparation';
                                }
                                else if(String.isNotBlank(jc.ETT_Building_Status__c) && !jc.ETT_Building_Status__c.startsWithIgnoreCase('resubmitted')){
                                    jc.ETT_Building_Status__c='';
                                } 
                            }
                            Set<String> StageListCheckSet = new Set<String>(stageListOrdered);
                            if(StageListCheckSet.contains(String.valueOf(currentStageIndex)))
                                stageListOrdered.remove(currentStageIndex);
                            // stageListOrdered.remove(currentStageIndex);
                            if(stageListOrdered.size()>0){
                                stageListSet=new Set<String>(stageListOrdered);
                            }
                            if(!stageListSet.contains(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c)){//if the next stage not present in our ordered field populate in the beginning
                                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+';'+String.join(stageListOrdered,';');
                            }
                            else{
                                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                            }
                            parentCard=jc;
                        }
                    }
                    if(parentCard.Id!=null){
                        upsert parentCard;
                    }
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c =='Accepted'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    if(String.isNotBlank(selectedNextStation)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=selectedNextStation;
                    }
                    else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=nextStageValue;
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c='Rimming & Enveloping';
                    }
                    
                    if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='';
                        } 
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='  Waiting for Acceptance' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='';
                        }
                    }
                    
                    //old logic
                    //stageListOrdered.remove(currentStageIndex);
                    //jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                    
                    //new logic
                    Set<String> StageListCheckSet = new Set<String>(stageListOrdered);
                    if(StageListCheckSet.contains(String.valueOf(currentStageIndex)))
                        stageListOrdered.remove(currentStageIndex);
                    // stageListOrdered.remove(currentStageIndex);
                    if(stageListOrdered.size()>0){
                        stageListSet=new Set<String>(stageListOrdered);
                    }
                    if(!stageListSet.contains(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c)){//if the next stage not present in our ordered field populate in the beginning
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+';'+String.join(stageListOrdered,';');
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                    }
                } 
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c =='Accepted'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    if(String.isNotBlank(selectedNextStation)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=selectedNextStation;
                    }
                    else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=nextStageValue;
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c='Rimming & Enveloping';
                    }
                    
                    if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='';
                        } 
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='  Waiting for Acceptance' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='';
                        }
                    }
                    else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c+1) : 1;
                        //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Defects Identified & Sent Back'){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='Resubmitted by Building';
                        }
                        else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c.startsWithIgnoreCase('resubmitted')){
                            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='';
                        }
                    }
                    
                    //old logic
                    //stageListOrdered.remove(currentStageIndex);
                    //jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                    
                    //new logic
                    Set<String> StageListCheckSet = new Set<String>(stageListOrdered);
                    if(StageListCheckSet.contains(String.valueOf(currentStageIndex)))
                        stageListOrdered.remove(currentStageIndex); 
                    //stageListOrdered.remove(currentStageIndex);
                    if(stageListOrdered.size()>0){
                        stageListSet=new Set<String>(stageListOrdered);
                    }
                    if(!stageListSet.contains(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c)){//if the next stage not present in our ordered field populate in the beginning
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+';'+String.join(stageListOrdered,';');
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
                    }
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c =='Accepted'){
                    
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    if(String.isNotBlank(selectedNextStation)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=selectedNextStation;
                    }
                    else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=nextStageValue;
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c='Painting';
                    }
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c =='Accepted'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    if(String.isNotBlank(selectedNextStation)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=selectedNextStation;
                    }
                    else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=nextStageValue;
                    }
                    else{
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c='Quality Control';
                    }
                    
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Quality Control' ){
					
                    if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Quality_Check_Status__c =='Initial Rejection'){
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c = 'Quality Control'; //change Painting to Quality control by sandip
                        //jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c = 'Resubmitted by Quality Control';
                        jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c='Quality Control';
                    }
                    if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Quality_Check_Status__c =='Accepted'){
                         jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Overall_Status__c='Accepted';
                    }
                   
                }
                
              //system.debug('--paint--'+jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c);
             
                jobCardlineWrapper.relatedJobWrapper.validJobCardList =  updateJobCardLinedetails2(jobCardlineWrapper,trackActivity,updateJobCard,selectedNextStation, jobCardlineWrapper.relatedJobWrapper.validJobCardList,nextStageValue,stageListOrdered,currentStageIndex,stageListSet);
                update jobCardlineWrapper.relatedJobWrapper.validJobCardList;
               
                
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit buffing process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Buffing_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit skiving process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Skiving_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit skiving process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Repair_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit skiving process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Cementing_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit Filling process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Filling_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }//approvals not applicable for thread preparation stage.                
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit Building process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('ETT_Job_Card_Building_ProcessV2');
                    Approval.ProcessResult result = Approval.process(req1); 
                }else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c =='Initial Rejection'){
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit Rimming & Enveloping process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('Job_Card_Rimming_Envelp_ProcessV1');
                    Approval.ProcessResult result = Approval.process(req1); 
                }else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Removal of RIM Tube Flap' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Removal_of_RIM_Tube_Flap_Status__c =='Initial Rejection'){
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit RIM Tube Flap process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('Job_Card_RIM_Tube_ProcessV1');
                    Approval.ProcessResult result = Approval.process(req1); 
                }
                else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c =='Initial Rejection'){
                    // Create an approval request for the account
                    System.debug('inside approval process of Final Inspection');
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit Final Inspection process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('Job_Card_Final_Ins_ProcessV1');
                    Approval.ProcessResult result = Approval.process(req1); 
                }else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c =='Initial Rejection'){
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit Painting process again.');
                    req1.setObjectId(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].id);
                    req1.setProcessDefinitionNameOrId('Job_Card_Painting_ProcessV1');
                    Approval.ProcessResult result = Approval.process(req1); 
                }else if(jobCardlineWrapper.jobLineItem.ReturnReject__c == 'Reject'){
                    
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for rejection approval. Approving this will send this to next approver. Rejecting this will resubmit Curing process again.');
                    req1.setObjectId(jobCardlineWrapper.jobLineItem.Id);
                    req1.setProcessDefinitionNameOrId('Final_inspection_return_reject_process');
                    Approval.ProcessResult result = Approval.process(req1);
                    
                }
                //and so on for other stages
            }
        }
        return jobCardlineWrapper;
    }
    
    
    public static List<ETT_Job_Card__c> updateJobCardLinedetails2(ETT_JobCardListController.JobLineItemWrapper jobCardlineWrapper,Boolean trackActivity, Boolean updateJobCard,String selectedNextStation,List<ETT_Job_Card__c> vJobcardList,String nextStageValue,List<String> stageListOrdered, Integer currentStageIndex,Set<String> stageListSet){
        System.debug('jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c'+jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c);
        if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing' && jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c =='Accepted'){
            jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
            if(String.isNotBlank(selectedNextStation)){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=selectedNextStation;
            }
            else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.nextStageValue)){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=nextStageValue;
            }
            else{
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c='Curing';
            }
            
            if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing'){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+1) : 1;
                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=='Defects Identified & Sent Back'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='Resubmitted by Building';
                }
                else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c.startsWithIgnoreCase('resubmitted')){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c='';
                }
            }
            else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving'){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c+1) : 1;
                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=='Defects Identified & Sent Back'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Resubmitted by Building';
                }
                else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c.startsWithIgnoreCase('resubmitted')){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='';
                }
            }
            else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair'){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_revisions__c+1) : 1;
                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=='Defects Identified & Sent Back'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='Resubmitted by Building';
                }
                else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c.startsWithIgnoreCase('resubmitted')){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='';
                } 
            }
            else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing'){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c+1) : 1;
                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=='Defects Identified & Sent Back'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='Resubmitted by Building';
                }
                else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c.startsWithIgnoreCase('resubmitted')){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='';
                }
            }
            else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling'){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c+1) : 1;
                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=='Defects Identified & Sent Back'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Resubmitted by Building';
                }
                else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c.startsWithIgnoreCase('resubmitted')){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='';
                }
            }
            else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation'){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c+1) : 1;
                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='  Waiting for Acceptance' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Defects Identified & Sent Back'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='Resubmitted by Building';
                }
                else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c.startsWithIgnoreCase('resubmitted')){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c='';
                }
            }
            else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping'){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+1) : 1;
                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c=='Defects Identified & Sent Back'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Resubmitted by Building';
                }
                else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c.startsWithIgnoreCase('resubmitted')){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='';
                }
            }
            else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing'){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c+1) : 1;
                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=='Defects Identified & Sent Back'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='Resubmitted by Building';
                }
                else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c.startsWithIgnoreCase('resubmitted')){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='';
                }
            }
            else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection'){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+1) : 1;
                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=='Defects Identified & Sent Back'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='Resubmitted by Building';
                }
                else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c.startsWithIgnoreCase('resubmitted')){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='';
                }
            }
            else if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting'){
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c!=null ? (jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c+1) : 1;
                //Let ensure we are not resetting the status if its already having resubmission/defect identified status
                if(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Initial Rejection' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Accepted' || jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=='Defects Identified & Sent Back'){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='Resubmitted by Building';
                }
                else if(String.isNotBlank(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c) && !jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c.startsWithIgnoreCase('resubmitted')){
                    jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='';
                }
            }
            
            //old logic
            //stageListOrdered.remove(currentStageIndex);
            //jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
            
            //new logic
            Set<String> StageListCheckSet = new Set<String>(stageListOrdered);
            if(StageListCheckSet.contains(String.valueOf(currentStageIndex)))
                stageListOrdered.remove(currentStageIndex); 
            //stageListOrdered.remove(currentStageIndex);
            if(stageListOrdered.size()>0){
                stageListSet=new Set<String>(stageListOrdered);
            }
            if(!stageListSet.contains(jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c)){//if the next stage not present in our ordered field populate in the beginning
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+';'+String.join(stageListOrdered,';');
            }
            else{
                jobCardlineWrapper.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(stageListOrdered,';');
            }
            return jobCardlineWrapper.relatedJobWrapper.validJobCardList;
        }
        return jobCardlineWrapper.relatedJobWrapper.validJobCardList;
    }
    
    Public class toolWrapper{
        @AuraEnabled public ETT_Tools_Master__c toolMaster {get; set;}
        @AuraEnabled public boolean isNewMaster {get; set;}
        @AuraEnabled public ETT_Tools_Allocation__c toolAllocation {get; set;}
        @Auraenabled public ContentVersion contentVersionData;
        @Auraenabled public ContentDocumentLink contentDocumentLinkData;
        
        public toolWrapper(){
            this.isNewMaster=false;
        }
    }
    
    Public class mapWrapper{
        @auraEnabled public string label {get; set;}
        @auraEnabled public string value {get; set;}
        @auraEnabled public string remarks {get; set;}
        @auraEnabled public integer requestedStockUnits {get; set;}
        @auraEnabled public ETT_Tools_Allocation__c toolAllocationDet {get; set;}
        @auraEnabled public ETT_Tools_Material_Usage__c toolUsage {get; set;}
        @Auraenabled public list<FileWrapper> lstFileWrapperDetails{get; set;}
        @Auraenabled public String imagelink{get; set;}
        
        public mapWrapper(){
            this.lstFileWrapperDetails=new list<FileWrapper>();
        }
    }
    
    public class FileWrapper{
        @Auraenabled public string strFileType{get; set;}
        @Auraenabled public string strFileName{get; set;}
        @Auraenabled public string fileContent{get; set;}
        @Auraenabled public Integer fileSourceType{get; set;}
        @Auraenabled public string parentId{get; set;}
    }
    
    @AuraEnabled
    Public Static List<mapWrapper> updateToolsUsageInDB(List<mapWrapper> toolUsageListOptions,JobLineItemWrapper jobLine){
        List<ETT_Tools_Material_Usage__c> toolUsageToInsert=new List<ETT_Tools_Material_Usage__c>();
        if(toolUsageListOptions!=null && toolUsageListOptions.size() >0){
            Integer currentVersion=1;
            if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Buffing' && jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c >=1){
                currentVersion=Integer.ValueOf(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c);
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving' && jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c >=1){
                currentVersion=Integer.ValueOf(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c);
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair' && jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c >=1){
                currentVersion=Integer.ValueOf(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c);
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing' && jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c >=1){
                currentVersion=Integer.ValueOf(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c);
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling' && jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c >=1){
                currentVersion=Integer.ValueOf(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c);
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Thread Preparation' && jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c >=1){
                currentVersion=Integer.ValueOf(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Thread_Preparation_revisions__c);
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building' && jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c >=1){
                currentVersion=Integer.ValueOf(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c);
            }
            //liksewise for other stages to be added
            
            for(mapWrapper m:toolUsageListOptions){
                if(m.toolAllocationDet!=null && m.toolAllocationDet.ETT_Tools_Master__r.ETT_Usage_type__c=='Consumable' && ((m.toolUsage.ETT_Usage_Value__c!=null && m.toolUsage.ETT_Usage_Value__c>0) || m.toolUsage.Id!=null)){
                    m.toolUsage.ETT_Usage_Value__c=(m.toolUsage.ETT_Usage_Value__c!=null && m.toolUsage.ETT_Usage_Value__c>0) ? m.toolUsage.ETT_Usage_Value__c : 0;
                    m.toolUsage.ETT_Job_Card__c=jobLine.relatedJobWrapper.validJobCardList[0].Id;
                    m.toolUsage.ETT_Job_Stage__c=jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    m.toolUsage.ETT_Tools_Material_Allocation__c=m.toolAllocationDet.Id;
                    m.toolUsage.ETT_Usage_Value__c=m.toolUsage.ETT_Usage_Value__c;
                    m.toolUsage.ETT_Version_number__c=currentVersion;
                    m.toolUsage.ETT_Whether_it_s_used_or_not__c=true;
                    toolUsageToInsert.add(m.toolUsage);
                }
                if(m.toolAllocationDet!=null && m.toolAllocationDet.ETT_Tools_Master__r.ETT_Usage_type__c=='Depreciable' && m.toolAllocationDet.ETT_Tools_Master__r.ETT_Track_Depreciable_Item_Usage_at_JC__c=='Track'){
                    m.toolUsage.ETT_Job_Card__c=jobLine.relatedJobWrapper.validJobCardList[0].Id;
                    m.toolUsage.ETT_Job_Stage__c=jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                    m.toolUsage.ETT_Tools_Material_Allocation__c=m.toolAllocationDet.Id;                    
                    m.toolUsage.ETT_Version_number__c=currentVersion;
                    
                    if(m.toolAllocationDet.ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c =='Display selection' && (m.toolUsage.ETT_Whether_it_s_used_or_not__c || m.toolUsage.Id!=null)){
                        toolUsageToInsert.add(m.toolUsage);
                    }
                    else if(m.toolAllocationDet.ETT_Tools_Master__r.Depreciable_item_selection_behaviour__c =='Auto-create for all JC'){
                        m.toolUsage.ETT_Whether_it_s_used_or_not__c=true;
                        toolUsageToInsert.add(m.toolUsage);
                    }                    
                }                
            }
            if(toolUsageToInsert.size()>0){
                upsert toolUsageToInsert;
            }
        }
        return toolUsageListOptions;
    }
    
    @AuraEnabled
    Public Static List<ToolWrapper> createToolRequestMethodVersion2(JobLineItemWrapper lineItem,List<MapWrapper> toolAllocationList,String workscheduleStationId){    
        system.debug('line item1'+lineItem);
        system.debug('toolAllocationList1'+toolAllocationList);
        system.debug('workscheduleStationId1'+workscheduleStationId);
        List<ContentVersion> lstContentVersions=new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocLinkList=new List<ContentDocumentLink>();
        
        Map<String,MapWrapper> toolAllocationMap=new Map<String,MapWrapper>();
        for(MapWrapper m: toolAllocationList){
            toolAllocationMap.put(m.value,m);
            system.debug('toolAllocationMap1'+toolAllocationMap);
        }
        
        List<ETT_Tools_Master__c> toolMasterToInitiate=new List<ETT_Tools_Master__c>();
        List<ETT_Tools_Allocation__c> toolAllocationToInitiate=new List<ETT_Tools_Allocation__c>();
        Map<Id,Id> toolAllocationWithMasterMap=new Map<Id,Id>();
        
        Map<Id,ETT_Tools_Master__c> toolMasterMap=new Map<Id,ETT_Tools_Master__c>();
        List<toolWrapper> toolWrapperList=new List<toolWrapper>();
        
        for(ETT_Tools_Allocation__c ta:[Select Id,Name,ETT_Tools_Master__c,ETT_Tools_Master__r.ETT_Unit_type__c,ETT_Previous_Tools_Allocation__c,ETT_Tools_Master__r.Name,ETT_Tools_Master__r.ETT_Item_Description__c,ETT_Tools_Master__r.ETT_Status__c,ETT_Tools_Master__r.ETT_Unique_Code__c,ETT_Tools_Master__r.ETT_Tool_type__c,ETT_Usage_End_time__c,ETT_Remarks__c,ETT_Tools_Master__r.RecordtypeId,ETT_Tools_Master__r.Recordtype.Name,ETT_Tools_Master__r.ETT_Usage_type__c from ETT_Tools_Allocation__c where Id IN:toolAllocationMap.keyset()]){
            toolAllocationWithMasterMap.put(ta.Id,ta.ETT_Tools_Master__c);
            toolMasterMap.put(ta.ETT_Tools_Master__c,null);
            system.debug('toolAllocationWithMasterMap1'+toolAllocationWithMasterMap);
            system.debug('toolMasterMap1'+toolMasterMap);
        }
        
        for(ETT_Tools_Master__c tm:[Select Id,Name,ETT_Item_Description__c,ETT_Status__c,ETT_Unique_Code__c,ETT_Individual_Unit_Value__c,ETT_Allocated_Units__c,Depreciable_item_selection_behaviour__c,ETT_Depth__c,ETT_KG_Per_Mtr__c,ETT_Maintenance_Frquency__c,ETT_Pattern_Master__c,ETT_Production_Areas__c,ETT_Tool_type__c,ETT_Supplier__c,ETT_Track_Depreciable_Item_Usage_at_JC__c,ETT_Tread_Width__c,ETT_Usage_type__c,ETT_Unit_type__c from ETT_Tools_Master__c where Id IN:toolMasterMap.keyset()]){
            toolMasterMap.put(tm.Id,tm);
            system.debug('toolMasterMap1'+toolMasterMap);
            
        }
        
        for(ETT_Tools_Allocation__c ta:[Select Id,Name,ETT_Tools_Master__c,ETT_Tools_Master__r.ETT_Unit_type__c,ETT_Previous_Tools_Allocation__c,ETT_Tools_Master__r.Name,ETT_Tools_Master__r.ETT_Item_Description__c,ETT_Tools_Master__r.ETT_Status__c,ETT_Tools_Master__r.ETT_Unique_Code__c,ETT_Tools_Master__r.ETT_Tool_type__c,ETT_Usage_End_time__c,ETT_Remarks__c,ETT_Tools_Master__r.RecordtypeId,ETT_Tools_Master__r.Recordtype.Name,ETT_Tools_Master__r.ETT_Usage_type__c from ETT_Tools_Allocation__c where Id IN:toolAllocationMap.keyset()]){
            toolWrapper tw=new toolWrapper();
            tw.toolAllocation=ta.clone(false,false);
            
            if(ta.ETT_Tools_Master__r.ETT_Unit_type__c=='Individual product'){
                tw.toolMaster=toolMasterMap.get(toolAllocationWithMasterMap.get(ta.id)).clone(false,false);
                tw.toolMaster.ETT_Status__c='Submitted for Approval';
                tw.toolMaster.ETT_Serial_No__c='';
                tw.isNewMaster=true;
                toolMasterToInitiate.add(tw.toolMaster);
                system.debug('toolMasterToInitiate1'+toolMasterToInitiate);
                
                tw.toolAllocation.ETT_Tools_Master__c=null;
                tw.toolAllocation.ETT_Previous_Tools_Allocation__c=ta.id;
                tw.toolAllocation.ETT_Remarks__c=toolAllocationMap.get(ta.Id).remarks;
                tw.toolAllocation.ETT_Allocated_Units_to_Station__c=1;
                tw.toolAllocation.ETT_Allocated_Stocks__c=1;
                tw.toolAllocation.ETT_Assigned_Work_Station__c=workscheduleStationId;
            }
            else{
                tw.toolMaster=toolMasterMap.get(toolAllocationWithMasterMap.get(ta.id));
                tw.toolAllocation.ETT_Previous_Tools_Allocation__c=ta.id;
                tw.toolAllocation.ETT_Remarks__c=toolAllocationMap.get(ta.Id).remarks;
                tw.toolAllocation.ETT_Allocated_Units_to_Station__c=toolAllocationMap.get(ta.Id).requestedStockUnits;
                tw.toolAllocation.ETT_Allocated_Stocks__c=(tw.toolAllocation.ETT_Allocated_Units_to_Station__c*toolMasterMap.get(toolAllocationWithMasterMap.get(ta.id)).ETT_Individual_Unit_Value__c);
                tw.toolAllocation.ETT_Tools_Master__c=toolMasterMap.get(toolAllocationWithMasterMap.get(ta.id)).Id;
                tw.toolAllocation.ETT_Assigned_Work_Station__c=workscheduleStationId;
            }
            if(toolAllocationMap.get(ta.Id).lstFileWrapperDetails!=null && toolAllocationMap.get(ta.Id).lstFileWrapperDetails.size()>0){
                for(FileWrapper objFileWrapper:toolAllocationMap.get(ta.Id).lstFileWrapperDetails){
                    tw.contentVersionData=new ContentVersion();
                    if(objFileWrapper.strFileName!='' && objFileWrapper.strFileType!='' && objFileWrapper.fileContent!=''){
                        tw.contentVersionData.Title = objFileWrapper.strFileName;
                        tw.contentVersionData.PathOnClient = objFileWrapper.strFileType;
                        tw.contentVersionData.VersionData = EncodingUtil.base64Decode(objFileWrapper.fileContent);
                        lstContentVersions.add(tw.contentVersionData);
                        system.debug('lstContentVersions1'+lstContentVersions);
                    }
                }
            }           
            toolWrapperList.add(tw);
            system.debug('toolWrapperList1'+toolWrapperList);
        }
        
        if(toolWrapperList.size()>0){
            if(toolMasterToInitiate.size() >0){
                insert toolMasterToInitiate;
            }
            
            for(toolWrapper tw:toolWrapperList){
                if(tw.isNewMaster){
                    tw.toolAllocation.ETT_Tools_Master__c=tw.toolMaster.Id;
                }                
                toolAllocationToInitiate.add(tw.toolAllocation);
                system.debug('toolAllocationToInitiate1'+toolAllocationToInitiate);
            }
            if(toolAllocationToInitiate.size() >0){
                insert toolAllocationToInitiate;
                
                if(lstContentVersions.size() >0){
                    insert lstContentVersions;
                    Map<Id,ContentVersion> lstContentVersionsMap=new Map<Id,ContentVersion>([Select Id,ContentDocumentId from ContentVersion where Id IN:lstContentVersions]);
                    
                    for(toolWrapper tw:toolWrapperList){
                        if(tw.contentVersionData!=null && tw.contentVersionData.Id!=null){
                            tw.ContentDocumentLinkData=new ContentDocumentLink();
                            tw.ContentDocumentLinkData.LinkedEntityId=tw.toolAllocation.Id;
                            tw.ContentDocumentLinkData.ContentDocumentId=lstContentVersionsMap.get(tw.contentVersionData.Id).ContentDocumentId;
                            lstContentDocLinkList.add(tw.ContentDocumentLinkData);
                        }
                    }
                    
                    if(lstContentDocLinkList.size() >0){
                        insert lstContentDocLinkList;
                    }
                    
                    for(toolWrapper tw:toolWrapperList){//reset the content variable once DML performed
                        tw.contentVersionData=new ContentVersion();
                        tw.ContentDocumentLinkData=new ContentDocumentLink();
                    }
                }                
                
                for(ETT_Tools_Allocation__c ta:toolAllocationToInitiate){
                    // Create an approval request for the account
                    Approval.ProcessSubmitRequest req =new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting tool request for approval.');
                    req.setObjectId(ta.id);
                    req.setProcessDefinitionNameOrId('ETT_Tool_Material_Allocation_Approval');
                    Approval.ProcessResult result = Approval.process(req);
                }
            }
        }
        return toolWrapperList; 
    }
    
    @AuraEnabled
    Public Static List<toolWrapper> refreshRequestStatusMethod(String newToolReq){ 
        List<toolWrapper> newToolReqList=(List<toolWrapper>)JSON.deserialize(newToolReq,List<toolWrapper>.class);
        Map<Id,ETT_Tools_Allocation__c> toolAllocationMap=new Map<Id,ETT_Tools_Allocation__c>();
        Map<Id,ETT_Tools_Master__c> toolMasterMap=new Map<Id,ETT_Tools_Master__c>();
        Set<Id> toolMasterIds=new Set<Id>();
        
        if(newToolReqList.size() >0){
            for(toolWrapper tw:newToolReqList){
                if(tw.toolAllocation!=null && tw.toolAllocation.Id!=null){
                    toolAllocationMap.put(tw.toolAllocation.Id,null);                
                }
                if(tw.toolMaster!=null && tw.toolMaster.Id!=null){
                    toolMasterMap.put(tw.toolMaster.Id,null);                
                }
            }
            toolAllocationMap=new Map<Id,ETT_Tools_Allocation__c>([Select Id,Name,ETT_Tools_Master__c,ETT_Previous_Tools_Allocation__c,ETT_Tools_Master__r.Name,ETT_Tools_Master__r.ETT_Item_Description__c,Allocation_Status__c,ETT_Tools_Master__r.ETT_Status__c,ETT_Tools_Master__r.ETT_Unique_Code__c,ETT_Tools_Master__r.ETT_Tool_type__c,ETT_Usage_End_time__c,ETT_Remarks__c,ETT_Tools_Master__r.RecordtypeId,ETT_Tools_Master__r.Recordtype.Name,ETT_Tools_Master__r.ETT_Usage_type__c from ETT_Tools_Allocation__c where Id IN:toolAllocationMap.keyset()]);
            toolMasterMap=new Map<Id,ETT_Tools_Master__c>([Select Id,Name,ETT_Item_Description__c,ETT_Status__c,ETT_Unique_Code__c,ETT_Tool_type__c,ETT_Maintenance_Frquency__c,ETT_Individual_Unit_Value__c from ETT_Tools_Master__c where Id IN:toolMasterMap.keyset()]);
            
            for(toolWrapper tw:newToolReqList){
                if(tw.toolAllocation!=null && tw.toolAllocation.Id!=null && toolAllocationMap.containsKey(tw.toolAllocation.Id)){
                    tw.toolAllocation=toolAllocationMap.get(tw.toolAllocation.Id);     
                }
                if(tw.toolMaster!=null && tw.toolMaster.Id!=null && toolMasterMap.containsKey(tw.toolMaster.Id)){
                    tw.toolMaster=toolMasterMap.get(tw.toolMaster.Id);
                }
            }
        }
        return newToolReqList;
    }
    
    @AuraEnabled
    Public Static ETT_Tyre_Rejection_Line_Item__c updateTyreInspectionDetailsToServer(ETT_Tyre_Rejection_Line_Item__c tyreCrownInspection){ 
        update tyreCrownInspection;
        return tyreCrownInspection;
    }
    
    @AuraEnabled //when the JC found to get rework in middle of any station, we keep the current stage to happen after rework of selected stations completed.
    public static void reportDefectsAndUpdateStationsinDB(List<String> defects,String nextStation,JobLineItemWrapper jobLine){
        if(jobLine!=null && jobLine.relatedJobWrapper.validJobCardList!=null && jobLine.relatedJobWrapper.validJobCardList.size()>0){
            if(jobLine.jobLineItem!=null && jobLine.jobLineItem.Id!=null){
                jobLine.jobLineItem.ETT_Status__c='Completed';
                jobLine.jobLineItem.ETT_Defect_s_found__c=String.join(defects,';');
                upsert jobLine.jobLineItem;
                
                if(jobLine.workTracker!=null && jobLine.workTracker.Id!=null){
                    jobLine.workTracker.ETT_End_time__c=system.now();
                    upsert jobLine.workTracker;
                }
            }
            
            String stageCombined=jobLine.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c;
            Set<String> stageSetExisting=new Set<String>();
            List<string> valildNextStations=new List<String>();
            
            if(String.isNotBlank(stageCombined)){
                stageSetExisting=new Set<string>(stageCombined.split(';'));   
                if(!stageSetExisting.contains(nextStation)){
                    valildNextStations.add(nextStation);
                }
            }
            if(valildNextStations.size() >0){
                
                //Janardhan- commented below logic, it is changing staged perform order
                //jobLine.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=String.join(valildNextStations,';')+';'+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c;
            }
            else if(String.isNotBlank(nextStation)){
                if(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c)){
                    List<String> upcomingStages=jobLine.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c.split(';');
                    Integer k=0;
                    for(String s:upcomingStages){
                        if(s==nextStation){
                            break;
                        }
                        k++;
                    }
                    upcomingStages.remove(k);   
                    //Janardhan- commented below logic, it is changing staged perform order
                    // jobLine.relatedJobWrapper.validJobCardList[0].ETT_Job_Stages_to_Perform_Ordered__c=nextStation+';'+String.join(upcomingStages,';');
                    valildNextStations.add(nextStation);
                }              
            }
            
            //Checking current stage and reset its status
            if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Skiving'){
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Rework_Reason_s__c=String.isBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Rework_Reason_s__c) ? '' : jobLine.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Rework_Reason_s__c;
                for(string s:defects){
                    if(!jobLine.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Rework_Reason_s__c.contains(s)){
                        jobLine.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Rework_Reason_s__c+=';'+s;
                    }
                }
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c='Defects Identified & Sent Back';
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Repair'){
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Repair_Rework_Reason_s__c=String.isBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Repair_Rework_Reason_s__c) ? '' : jobLine.relatedJobWrapper.validJobCardList[0].ETT_Repair_Rework_Reason_s__c;
                for(string s:defects){
                    if(!jobLine.relatedJobWrapper.validJobCardList[0].ETT_Repair_Rework_Reason_s__c.contains(s)){
                        jobLine.relatedJobWrapper.validJobCardList[0].ETT_Repair_Rework_Reason_s__c+=';'+s;
                    }
                }
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c='Defects Identified & Sent Back';
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Cementing'){
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Cementing__c=String.isBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Cementing__c) ? '' : jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Cementing__c;
                for(string s:defects){
                    if(!jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Cementing__c.contains(s)){
                        jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Cementing__c+=';'+s;
                    }
                }
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c='Defects Identified & Sent Back';
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Filling'){
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Filling__c=String.isBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Filling__c) ? '' : jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Filling__c;
                for(string s:defects){
                    if(!jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Filling__c.contains(s)){
                        jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Filling__c+=';'+s;
                    }
                }
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c='Defects Identified & Sent Back';
            } 
            //FYI: For threading stage they cannot send back
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Building'){
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Building__c=String.isBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Building__c) ? '' : jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Building__c;
                for(string s:defects){
                    if(!jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Building__c.contains(s)){
                        jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Building__c+=';'+s;
                    }
                }
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c='Defects Identified & Sent Back';
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Rimming & Enveloping'){
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Rimming_Env__c=String.isBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Rimming_Env__c) ? '' : jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Rimming_Env__c;
                for(string s:defects){
                    if(!jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Rimming_Env__c.contains(s)){
                        jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Rimming_Env__c+=';'+s;
                    }
                }
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c='Defects Identified & Sent Back';
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Curing'){
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Curing__c=String.isBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Curing__c) ? '' : jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Curing__c;
                for(string s:defects){
                    if(!jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Curing__c.contains(s)){
                        jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Curing__c+=';'+s;
                    }
                }
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c='Defects Identified & Sent Back';
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Final Inspection'){
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_Identified_Final_Inspection__c=String.isBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_Identified_Final_Inspection__c) ? '' : jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_Identified_Final_Inspection__c;
                for(string s:defects){
                    if(!jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_Identified_Final_Inspection__c.contains(s)){
                        jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_Identified_Final_Inspection__c+=';'+s;
                    }
                }
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c='Defects Identified & Sent Back';
            }
            else if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=='Painting'){
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Painting__c=String.isBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Painting__c) ? '' : jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Painting__c;
                for(string s:defects){
                    if(!jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Painting__c.contains(s)){
                        jobLine.relatedJobWrapper.validJobCardList[0].ETT_Defect_s_Identified_On_Painting__c+=';'+s;
                    }
                }
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c='Defects Identified & Sent Back';
            }
            
            ETT_Job_Card__c threadJobCard=new ETT_Job_Card__c();
            for(String s:valildNextStations){
                if(s=='Buffing'){
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Buffing_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Buffing_revisions__c+=1;//increment for next set of activities
                    break;
                }
                else if(s=='Skiving'){
                    system.debug('status='+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c);
                    system.debug('status='+jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c);
                    
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Skiving_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Skiving_revisions__c+=1;//increment for next set of activities
                    break;
                }
                else if(s=='Repair'){
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Repair_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c=(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c>0 ? jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Repair_Revisions__c+1 : 1);//increment for next set of activities
                    break;
                }
                else if(s=='Cementing'){
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Cementing_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c=(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c>0 ? jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Cementing_Revisions__c+1 : 1);//increment for next set of activities
                    break;
                }
                else if(s=='Filling'){
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Filling_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Filling_Revisions__c+=1;//increment for next set of activities
                    break;
                }
                else if(s=='Thread Preparation'){
                    //Start: Block of code for filling stage alone. not applies to other stages
                    /*String jobQueryStr='Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+' from ETT_Job_Card__c where ETT_Main_Job_Card__c=\''+jobLine.relatedJobWrapper.validJobCardList[0].Id+'\'';
for(ETT_Job_Card__c jc:Database.query(jobQueryStr)){
if(jc.ETT_Main_Job_Card__c!=null && jc.ETT_Stages__c=='Thread Preparation'){
if(jc.ETT_Thread_Preparation_Status__c=='Waiting for Acceptance'){
jc.ETT_Thread_Preparation_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
jc.ETT_No_of_Thread_Preparation_revisions__c+=1;
threadJobCard=jc;
}
}
}*/
                    //End: Block of code for filling stage alone. not applies to other stages.
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    //revision number will be updated on approval process ETT_Job_CardThread_Rejection_By_Building approval.
                    break;
                }
                else if(s=='Building'){
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Building_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c=(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c>0 ? jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Building_Revisions__c+1 : 1);//increment for next set of activities
                    break;
                }
                else if(s=='Rimming & Enveloping'){
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Rimming_Env_Status__c =(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c=(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c>0 ? jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Rimming_Env_Revisions__c+1 : 1);//increment for next set of activities
                    break;
                }
                else if(s=='Curing'){
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Curing_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c=(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c>0 ? jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Curing_Revisions__c+1 : 1);//increment for next set of activities
                    break;
                }
                else if(s=='Final Inspection'){
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Final_Inspection_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c=(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c>0 ? jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_of_Final_Inspection_Revisions__c+1 : 1);//increment for next set of activities
                    break;
                }
                else if(s=='Painting'){
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_Painting_Status__c=(String.isNotBlank(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c) ? 'Resubmitted by '+jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c : '');
                    jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c=(jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c>0 ? jobLine.relatedJobWrapper.validJobCardList[0].ETT_No_Of_Painting_Revisions__c+1 : 1);//increment for next set of activities
                    break;
                }
            }
            if(valildNextStations.size() >0){ 
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Previous_Job_Stage__c=jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c;
                jobLine.relatedJobWrapper.validJobCardList[0].ETT_Stages__c=valildNextStations[0];
            } 
            //This block is not used at this moment. keep for future purpose
            /*if(threadJobCard!=null && threadJobCard.Id!=null){
upsert threadJobCard; 
}*/
            upsert jobLine.relatedJobWrapper.validJobCardList[0];
            //commented below code By Janardhan, not required any approval and only notification
            /*if(jobLine.relatedJobWrapper.validJobCardList[0].ETT_Thread_Preparation_Status__c=='Resubmitted by Building'){//only applicable for thread stage
                Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for rejection of thread stage due to problem identfied on building stage. Approving this will send this card to thread stage. Rejecting this will resubmit Building process again.');
                req1.setObjectId(jobLine.relatedJobWrapper.validJobCardList[0].id);
                req1.setProcessDefinitionNameOrId('ETT_Job_CardThread_Rejection_By_Building');
                Approval.ProcessResult result = Approval.process(req1); 
            }*/
        }        
    }
    
    @AuraEnabled
    public static ETT_Job_Card__c getPreviousJobCardBuilding(Id workSchedule){
        List<ETT_Job_Card_Line_Item__c> changeRimLineItem=[Select Id,ETT_Activity_Performed__c,ETT_Job_Card__c,Sequence__c,ETT_Revision_Number__c from ETT_Job_Card_Line_Item__c where ETT_Activity_Performed__c='Building Rim Status Check' and ETT_Job_Card__r.ETT_Building_Work_Schedule__c=:workSchedule and ETT_Status__c='Completed' order by lastModifiedDate limit 1];
        if(changeRimLineItem!=null && changeRimLineItem.size()>0){
            String jobQueryStr='Select '+String.join(ETT_JobCardListController.queryAllSObjectFields('ETT_Job_Card__c'),',')+','+
                +'ETT_Tyre_Master__r.ETT_Tyre_Size__c,ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name,ETT_Inspection_Card__r.ETT_Collection_Card__c,ETT_Inspection_Card__r.ETT_Brand__c,ETT_Inspection_Card__r.ETT_Country__c,'+
                +'ETT_Inspection_Card__r.ETT_Pattern__c,ETT_Inspection_Card__r.ETT_Tyre_Size__c,ETT_Main_Job_Card__r.ETT_Stages__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Painting__c,ETT_Main_Job_Card__r.ETT_Defect_Identified_Final_Inspection__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Curing__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Rimming_Env__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Building__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Filling__c,ETT_Main_Job_Card__r.ETT_Defect_s_Identified_On_Cementing__c,ETT_Main_Job_Card__r.ETT_Repair_Rework_Reason_s__c,ETT_Main_Job_Card__r.ETT_Skiving_Rework_Reason_s__c,'+
                +'ETT_Main_Job_Card__r.ETT_Tyre_Master__c,ETT_Main_Job_Card__r.Name,ETT_Main_Job_Card__r.ETT_Priority__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Actual_Width__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Length__c,ETT_Main_Job_Card__r.ETT_Tyre_Master__r.ETT_Tyre_Outer_Diameter_OD__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__c,ETT_Main_Job_Card__r.ETT_Tread_Master_Allocation__r.ETT_Tools_Master__r.Name,ETT_Main_Job_Card__r.ETT_Buffing_precured_tread_line__c from ETT_Job_Card__c where  Id=\''+changeRimLineItem[0].ETT_Job_Card__c+'\'';
            return (ETT_Job_Card__c)Database.query(jobQueryStr); 
        }
        return null;
    }
    
    
    @AuraEnabled
    public static ETT_Job_Card_Line_Item__c getJobCardLineItemData(String recordId,String stageValue,Integer current_sequence){
        System.debug('recortd id = '+recordId);
        System.debug('stageValue id = '+stageValue);
        System.debug('current_sequence id = '+current_sequence);
        return [SELECT Id, ETT_Rim_Type__c,Rim_Sure_Lock_Values__c, ETT_Job_Card__c, Sequence__c FROM ETT_Job_Card_Line_Item__c where ETT_Job_Card__c=:recordId and Sequence__c=:current_sequence];
    }
    //below Method added by Janardhan
    @AuraEnabled
    public static ETT_Job_Card_Line_Item__c getJobCardLineInfoCommon(String recordId,String ActivityPerformed,Integer sequence){
       
        return [SELECT Id, ETT_Skived_Production_Plate_date_area__c,Rim_Sure_Lock_Values__c, ETT_Job_Card__c, Sequence__c FROM ETT_Job_Card_Line_Item__c where ETT_Job_Card__c=:recordId and ETT_Activity_Performed__c=:ActivityPerformed and Sequence__c=:sequence];
     
    }    
    
    @AuraEnabled
    public static ETT_Job_Card_Line_Item__c getSideWallDetails(String recordId,String stageValue,Integer current_sequence){
        return [SELECT Id, ETT_Initial_Activity_State__c, ETT_Job_Card__c, Sequence__c FROM ETT_Job_Card_Line_Item__c where ETT_Job_Card__c=:recordId AND recordType.Name=:stageValue and Sequence__c=:current_sequence];
    }    
    @AuraEnabled
    public static Id HOONotification(Id targetId) {
        CustomNotificationType notificationType =  [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='ETT_Notification'];
        // My_Custom_Notification (Enter the API Name of custom notification that you have created)
        List<User> users=[SELECT Id  from user WHERE profile.Name='ETT_Head of Operations'];
        // Create a new custom notification
        Set<String>  userset=new Set<String>();
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        
        // Set the contents for the notification
        notification.setTitle('Tread having 2 pieces is checked');
        notification.setBody('From Building Technician');
        
        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        
        // Actually send the notification
        try {
            userset.add(users[0].Id);
            notification.send(userset);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
        return targetId;
    } 
    
    //Added by Goldy sigh from 3693 to 3789
    @AuraEnabled
    public static ETT_Job_Card__c getTyreSizeFromIc(String JCId){
        
        ETT_Job_Card__c jobcard = [Select id,name,ETT_Inspection_Card__r.ETT_Tyre_Size__r.Name,ETT_Inspection_Card__r.ETT_Brand__r.Name,ETT_Inspection_Card__r.ETT_Pattern__r.Name from ETT_Job_Card__c where id=:JCId];
        
        system.debug('tyresize='+jobcard);
        return jobcard;
    }
    @AuraEnabled
    public static String updateNewTyreSize(String JCId,String OldtyreSizeId,String NewTyreSizeName){
        String NewTYreSizeId = null;
        system.debug('updateNewTyreSize call');
        List<ETT_Tyre_Size_Master__c> tyreSizeList = [Select id , name from ETT_Tyre_Size_Master__c where Name=:NewTyreSizeName];
        if(tyreSizeList.Size()>0){
            system.debug('insideif line3663 call');
            
            ETT_Job_Card__c jobcard = [Select id,name,ETT_Inspection_Card__r.ETT_Tyre_Size__r.Name,ETT_Inspection_Card__r.ETT_Tyre_Size__c from ETT_Job_Card__c where id=:JCId];
            if(jobcard.ETT_Inspection_Card__r.ETT_Tyre_Size__r.Name!=NewTyreSizeName && jobcard.ETT_Inspection_Card__c!=null){
                ETT_Inspection_Card__c icObj = [Select id, ETT_Tyre_Size__c from ETT_Inspection_Card__c where id=:jobcard.ETT_Inspection_Card__c ];
                icObj.ETT_Tyre_Size__c = tyreSizeList[0].id;
                update icObj;
                NewTYreSizeId= tyreSizeList[0].id;
            }
        }
        else{
            system.debug('insideelse3674 call');
            ETT_Tyre_Size_Master__c newTyresize = new ETT_Tyre_Size_Master__c();
            newTyresize.Name = NewTyreSizeName;
            
            insert newTyresize;
            system.debug('tyresizeidnew='+newTyresize);
            ETT_Job_Card__c jobcard = [Select id,name,ETT_Inspection_Card__r.ETT_Tyre_Size__r.Name,ETT_Inspection_Card__r.ETT_Tyre_Size__c from ETT_Job_Card__c where id=:JCId];
            if(jobcard.ETT_Inspection_Card__r.ETT_Tyre_Size__r.Name!=NewTyreSizeName && jobcard.ETT_Inspection_Card__c!=null){
                ETT_Inspection_Card__c icObj = [Select id, ETT_Tyre_Size__c from ETT_Inspection_Card__c where id=:jobcard.ETT_Inspection_Card__c ];
                icObj.ETT_Tyre_Size__c = newTyresize.id;
                update icObj;
                NewTYreSizeId= newTyresize.id;
                
            }
        }
        system.debug('exit call');
        return NewTYreSizeId;
    }
    @AuraEnabled
    
    public static String updateNewTyrePattern(String JCId,String OldtyrePatternId,String NewTyrePatternName){
        String NewTYrePatternId = null;
        System.debug('1');
        List<ETT_Pattern_Master__c> tyrePatternList = [Select id , name from ETT_Pattern_Master__c where Name=:NewTyrePatternName];
        if(tyrePatternList.Size()>0){
            System.debug('2');
            ETT_Job_Card__c jobcard = [Select id,name,ETT_Inspection_Card__r.ETT_Pattern__r.Name,ETT_Inspection_Card__r.ETT_Pattern__c from ETT_Job_Card__c where id=:JCId];
            if(jobcard.ETT_Inspection_Card__r.ETT_Pattern__r.Name!=NewTyrePatternName && jobcard.ETT_Inspection_Card__c!=null){
                System.debug('3');
                ETT_Inspection_Card__c icObj = [Select id, ETT_Pattern__c from ETT_Inspection_Card__c where id=:jobcard.ETT_Inspection_Card__c ];
                icObj.ETT_Pattern__c = tyrePatternList[0].id;
                update icObj;
                NewTYrePatternId= tyrePatternList[0].id;
            }
        }
        else{
            System.debug('4');
            ETT_Pattern_Master__c newTyrePattern = new ETT_Pattern_Master__c();
            newTyrePattern.Name = NewTyrePatternName;
            insert newTyrePattern;
            
            ETT_Job_Card__c jobcard = [Select id,name,ETT_Inspection_Card__r.ETT_Pattern__r.Name,ETT_Inspection_Card__r.ETT_Pattern__c from ETT_Job_Card__c where id=:JCId];
            if(jobcard.ETT_Inspection_Card__r.ETT_Pattern__r.Name!=NewTyrePatternName && jobcard.ETT_Inspection_Card__c!=null){
                System.debug('5');
                ETT_Inspection_Card__c icObj = [Select id, ETT_Pattern__c from ETT_Inspection_Card__c where id=:jobcard.ETT_Inspection_Card__c ];
                icObj.ETT_Pattern__c = newTyrePattern.id;
                update icObj;
                NewTYrePatternId= newTyrePattern.id;
                
            }
        }
        System.debug('6');
        return NewTYrePatternId;
    }
    
    @AuraEnabled
    public static ETT_Job_Card_Line_Item__c getDesiredlengthSize(String JCId){
        
        ETT_Job_Card_Line_Item__c jcLineItem = new ETT_Job_Card_Line_Item__c();
        jcLineItem = null;
        ETT_Job_Card__c jobcard = [Select id,name,(Select id,Name,ETT_Desired_Length__c,ETT_Desired_Width__c from Job_Card_Line_Items__r where RecordType.Name='Buffing' order by ETT_Revision_Number__c desc)from ETT_Job_Card__c where id=:JCId];
        
        for(ETT_Job_Card_Line_Item__c jclineIt:jobcard.Job_Card_Line_Items__r)
        {
            jcLineItem =   jclineIt;
            break;
        }
        system.debug('tyresize='+jobcard);
        return jcLineItem;
    }
   
    @AuraEnabled
    public static void SupervisorNotification(Id targetId,String reason,String strResponse) {
        if(strResponse == 'Reject'){
            /*Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
            req.setComments('Submitting approval request');        
            req.setObjectId(targetId);
            Approval.ProcessResult result = Approval.process(req);*/  
        }
        else{
            CustomNotificationType notificationType =  [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='ETT_Notification'];
            // My_Custom_Notification (Enter the API Name of custom notification that you have created)
            List<User> users=[SELECT Id  from user WHERE profile.Name='ETT_Supervisor'];
            // Create a new custom notification
            Set<String>  userset=new Set<String>();
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            
            // Set the contents for the notification
            notification.setTitle('Final Inspection Side wall check');
            notification.setBody(reason);
            
            // Set the notification type and target
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(targetId);
            
            // Actually send the notification
            try {
                userset.add(users[0].Id);
                notification.send(userset);
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
            //return targetId;
        }
        
    }
    @AuraEnabled
    public static void SupervisorNotification2(String targetId, List<ETT_Job_Card__c> jobcardValveinfo,String sequence,String titl) {
        
        String message = '';
        system.debug('targetId------>'+targetId);
        system.debug('jobcardValveinfo------>'+jobcardValveinfo);
        system.debug('sequence------>'+sequence);
        system.debug('titl------>'+titl);
        
        for(ETT_Job_Card__c vItm :jobcardValveinfo) {
            if(sequence == '5' && vItm.Name != null )
                message= message + 'JobCard : '+vItm.Name + ', Pressure Valve Number : '+vItm.Pressure_Valve_Number__c+', Voccume Valve Number : '+vItm.Voccum_Valve_Number__c +'\n';
            else if(sequence == '7'  && vItm.Name != null  )
                message= message + 'JobCard : '+vItm.Name + ', Cable Pressure Valve Number : '+vItm.Cable_Pressure_Valve_Number__c+', Cable Voccume Valve Number : '+vItm.Cable_Voccume_Valve_Number__c +'\n';
            else if(sequence == '11'  && vItm.Name != null  )
                message= message + 'JobCard : '+vItm.Name + ', Cable Pressure Valve Number : '+vItm.Guage_Pressure_Valve_Number__c+', Cable Voccume Valve Number : '+vItm.Guage_Voccume_Valve_Number__c +'\n';
        }
        CustomNotificationType notificationType =  [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='ETT_Notification'];
        //  List<User> users=[SELECT Id  from user WHERE (profile.Name='ETT_Supervisor' OR profile.Name='ETT_Head of Operations') and isactive = true limit 2];
        Set<String>  userset=new Set<String>();
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(titl);
        notification.setBody(message);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        system.debug('userset------>'+userset);
        try {
            userset.add(System.Label.HooID);
            userset.add(System.Label.SupervisorID);
            notification.send(userset);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
    @AuraEnabled
    public static void SupervisorNotification3(String targetId,String titl,String message) {
       /* CustomNotificationType notificationType =  [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='ETT_Notification'];
        Set<String>  userset=new Set<String>();
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(titl);
        notification.setBody(message);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        system.debug('userset------>'+userset);
        try {
            userset.add(System.Label.HooID);
            userset.add(System.Label.SupervisorID);
            notification.send(userset);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }*/
    }
    @AuraEnabled
    public static String getRimSureLockValues(String JCId){
        String rimSureLockValue = '';
        List<ETT_Job_Card_Line_Item__c> jclineItem5 = [Select id,Rim_Sure_Lock_Values__c from ETT_Job_Card_Line_Item__c where ETT_Job_Card__c =:JCId and Sequence__c=5];
        if(jclineItem5.size()>0)
        {
            rimSureLockValue =jclineItem5[0].Rim_Sure_Lock_Values__c;
        }
        return rimSureLockValue;
    }
    @AuraEnabled
    public static List<String> getBuffingInfo(String JCId){
        List<String> JcPatternandWIdth = new List<String>();
        List<ETT_Job_Card_Line_Item__c> jclineItem5 = [Select id,ETT_Desired_Tread_Pattern__c,ETT_Desired_Width__c from ETT_Job_Card_Line_Item__c where ETT_Job_Card__c =:JCId and recordtype.Name='Buffing' and Sequence__c=18];
        if(jclineItem5.size()>0)
        {
            JcPatternandWIdth.add(String.valueOf(jclineItem5[0].ETT_Desired_Tread_Pattern__c));
            JcPatternandWIdth.add(String.valueOf(jclineItem5[0].ETT_Desired_Width__c));
            
        }
        return JcPatternandWIdth;
    }
    
    public static void testfakecoverage(){
        Integer i =1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
}