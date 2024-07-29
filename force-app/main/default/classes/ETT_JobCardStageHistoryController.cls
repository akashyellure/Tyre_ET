public class ETT_JobCardStageHistoryController {
    public class JobCardHistoryWrapper{
        @AuraEnabled public Id jobCardId{get; set;}
        @AuraEnabled public String stageName {get; set;}
        @AuraEnabled public Datetime stageStartTime {get; set;}
        @AuraEnabled public Datetime stageEndTime {get; set;}
        @AuraEnabled public Integer versionNumber {get; set;}
        @AuraEnabled public String stageStatus {get; set;}
        @AuraEnabled public String techRemarks {get; set;}
        @AuraEnabled public String managerRemarks {get; set;}
        @AuraEnabled public String defectsStr {get; set;}
        @AuraEnabled public StageRevisionHistoryWrapper stageData {get; set;}
        
        public JobCardHistoryWrapper(){
            this.stageData=new StageRevisionHistoryWrapper();
        }
    }
    
    public class StageRevisionHistoryWrapper{
        @AuraEnabled public Integer revisionNumber {get; set;}
        @AuraEnabled public List<ETT_TyreInspectionCardWrapper.TyreRejectionLineItem> complaintLists{get; set;}
        
        public StageRevisionHistoryWrapper(){
            this.complaintLists=new List<ETT_TyreInspectionCardWrapper.TyreRejectionLineItem>();
        }
    }
    
    @AuraEnabled
    Public Static List<JobCardHistoryWrapper> getJobCardStageHistoryInfo(Id jobCardId,Id inspectionCardId,String currentStageName, Integer currentRevisionNumber){
        List<JobCardHistoryWrapper> historyList=new List<JobCardHistoryWrapper>();
        Map<String,Map<Integer,JobCardHistoryWrapper>> stageHistoryMap=new Map<String,Map<Integer,JobCardHistoryWrapper>>();
        Map<String,Map<Integer,StageRevisionHistoryWrapper>> stageWithRevisionHistoryMap=new Map<String,Map<Integer,StageRevisionHistoryWrapper>>();        
        Map<Id,Map<Id,Id>> parentIdWithContentDocumentLinkMap=new Map<Id,Map<Id,Id>>();
        Map<Id,ContentVersion> contentDocumentIdWithVersionMap=new Map<Id,ContentVersion>();
        
        for(ETT_Tyre_Rejection_Line_Item__c tyreRejLine:[Select Id,Name,ETT_Good_Condition__c,ETT_Inspection_Card__c,ETT_Job_Card__c,
                                                         (select Id,Name,ETT_Status__c from Tyre_Rejection_Sub_Line_Items__r where ETT_Status__c!=null)                                                      
                                                         from ETT_Tyre_Rejection_Line_Item__c where (ETT_Job_Card__c=:jobCardId OR ETT_Inspection_Card__c=:inspectionCardId) order by createdDate desc]){
            parentIdWithContentDocumentLinkMap.put(tyreRejLine.Id,new Map<Id,Id>());    
            if(tyreRejLine.Tyre_Rejection_Sub_Line_Items__r!=null){
                for(ETT_Tyre_Rejection_Sub_Line_Item__c sub:tyreRejLine.Tyre_Rejection_Sub_Line_Items__r){
                    parentIdWithContentDocumentLinkMap.put(sub.Id,new Map<Id,Id>());
                }
            }           
        }
        
        for(ETT_Tyre_Rejection_Line_Item__c tyreRejLine:[Select Id,Name,ETT_Good_Condition__c,ETT_Inspection_Card__c,ETT_Inspection_Card__r.ETT_Start_Time__c,ETT_Inspection_Card__r.ETT_End_Time__c,ETT_Job_Card__c,ETT_Version__c,ETT_Job_Stage__c,
                                                         ETT_Job_Card__r.ETT_Buffing_Start_Time_new__c,ETT_Job_Card__r.ETT_Buffing_End_time_new__c,ETT_Job_Card__r.ETT_No_of_Buffing_revisions__c,ETT_Job_Card__r.ETT_Buffing_Status__c,ETT_Job_Card__r.ETT_Buffing_Station_Work_Schedule__c,ETT_Job_Card__r.ETT_Buffing_Technician_Rejection_Remarks__c,ETT_Job_Card__r.ETT_Buffing_Rejection_Manager_Remarks__c,
                                                         ETT_Job_Card__r.ETT_Skiving_Start_time_new__c,ETT_Job_Card__r.ETT_Skiving_End_time_new__c,ETT_Job_Card__r.ETT_No_of_Skiving_revisions__c,ETT_Job_Card__r.ETT_Skiving_Status__c,ETT_Job_Card__r.ETT_Skiving_Station_Work_Schedule__c,ETT_Job_Card__r.ETT_Skiving_Technician_Rejection_Remarks__c,ETT_Job_Card__r.ETT_Skiving_Rejection_Manager_Remarks__c,ETT_Job_Card__r.ETT_Skiving_Rework_Reason_s__c,
                                                         ETT_Job_Card__r.ETT_Repair_Start_Time_new__c,ETT_Job_Card__r.ETT_Repair_End_Time_new__c,ETT_Job_Card__r.ETT_No_of_Repair_Revisions__c,ETT_Job_Card__r.ETT_Repair_Status__c,ETT_Job_Card__r.ETT_Repair_Work_Schedule__c,ETT_Job_Card__r.ETT_Repair_Technician_Rejection_Remarks__c,ETT_Job_Card__r.ETT_Repair_Rejection_Manager_Remarks__c,ETT_Job_Card__r.ETT_Repair_Rework_Reason_s__c,
                                                         ETT_Job_Card__r.ETT_Cementing_Start_time_new__c,ETT_Job_Card__r.ETT_Cementing_End_Time_new__c,ETT_Job_Card__r.ETT_No_of_Cementing_Revisions__c,ETT_Job_Card__r.ETT_Cementing_Status__c,ETT_Job_Card__r.ETT_Cementing_Work_Schedule__c,ETT_Job_Card__r.ETT_Cementing_Technici_Rejection_Remarks__c,ETT_Job_Card__r.ETT_Cementing_Rejection_Manager_Remarks__c,ETT_Job_Card__r.ETT_Defect_s_Identified_On_Cementing__c,
                                                         ETT_Job_Card__r.ETT_Filling_Start_Time_new__c,ETT_Job_Card__r.ETT_Filling_End_Time_new__c,ETT_Job_Card__r.ETT_No_of_Filling_Revisions__c,ETT_Job_Card__r.ETT_Filling_Status__c,ETT_Job_Card__r.ETT_Filling_Work_Schedule__c,ETT_Job_Card__r.ETT_Filling_Technician_Rejection_Remarks__c,ETT_Job_Card__r.ETT_Filling_Rejection_Manager_Remarks__c,ETT_Job_Card__r.ETT_Defect_s_Identified_On_Filling__c,
                                                         ETT_Job_Card__r.ETT_Thread_Prep_Start_Time__c,ETT_Job_Card__r.ETT_Thread_Prep_End_Time__c,ETT_Job_Card__r.ETT_No_of_Thread_Preparation_revisions__c,ETT_Job_Card__r.ETT_Thread_Preparation_Status__c,ETT_Job_Card__r.ETT_Thread_Preparation_Work_Schedule__c,ETT_Job_Card__r.ETT_Thread_Technician_Rejection_Remarks__c,ETT_Job_Card__r.ETT_Thread_Rejection_Manager_Remarks__c,
                                                         ETT_Job_Card__r.ETT_Building_Start_Time_new__c,ETT_Job_Card__r.ETT_Building_End_Time_new__c,ETT_Job_Card__r.ETT_No_of_Building_Revisions__c,ETT_Job_Card__r.ETT_Building_Status__c,ETT_Job_Card__r.ETT_Building_Work_Schedule__c,ETT_Job_Card__r.ETT_Building_Technician_Reject_Remarks__c,ETT_Job_Card__r.ETT_Building_Rejection_Manager_Remarks__c,ETT_Job_Card__r.ETT_Defect_s_Identified_On_Building__c,
                                                         ETT_Job_Card__r.ETT_Rimming_Env_Start_Time__c,ETT_Job_Card__r.ETT_Rimming_Env_End_Time__c,ETT_Job_Card__r.ETT_No_of_Rimming_Env_Revisions__c,ETT_Job_Card__r.ETT_Rimming_Env_Status__c,ETT_Job_Card__r.ETT_Rimming_Env_Schedule__c,ETT_Job_Card__r.ETT_Rimming_Env_Technician_Reject_Remark__c,ETT_Job_Card__r.ETT_Rimming_Env_Manager_Remarks__c,ETT_Job_Card__r.ETT_Defect_s_Identified_On_Rimming_Env__c,
                                                         ETT_Job_Card__r.ETT_Curing_Start_Time_new__c,ETT_Job_Card__r.ETT_Curing_End_Time_new__c,ETT_Job_Card__r.ETT_No_of_Curing_Revisions__c,ETT_Job_Card__r.ETT_Curing_Status__c,ETT_Job_Card__r.ETT_Curing_Work_Schedule__c,ETT_Job_Card__r.ETT_Curing_Technician_Rejection_Remarks__c,ETT_Job_Card__r.ETT_Curing_Rejection_Manager_Remarks__c,ETT_Job_Card__r.ETT_Defect_s_Identified_On_Curing__c,
                                                         ETT_Job_Card__r.ETT_Final_Inspection_Start_Time_new__c,ETT_Job_Card__r.ETT_Final_Inspection_End_Time_new__c,ETT_Job_Card__r.ETT_No_of_Final_Inspection_Revisions__c,ETT_Job_Card__r.ETT_Final_Inspection_Status__c,ETT_Job_Card__r.ETT_Final_Inspection_Work_Schedule__c,ETT_Job_Card__r.ETT_Final_Inspection_Technician_Remarks__c,ETT_Job_Card__r.ETT_Final_Inspection_Manager_Remarks__c,ETT_Job_Card__r.ETT_Defect_Identified_Final_Inspection__c,
                                                         ETT_Job_Card__r.ETT_Painting_Start_Time_new__c,ETT_Job_Card__r.ETT_Painting_End_Time_new__c,ETT_Job_Card__r.ETT_No_Of_Painting_Revisions__c,ETT_Job_Card__r.ETT_Painting_Status__c,ETT_Job_Card__r.ETT_Painting_Work_Schedule__c,ETT_Job_Card__r.ETT_Painting_Technician_Remarks__c,ETT_Job_Card__r.ETT_Painting_Manager_Remarks__c,ETT_Job_Card__r.ETT_Defect_s_Identified_On_Painting__c,
                                                         ETT_Number_of_cuts_0_10_mm__c,ETT_Number_of_cuts_11_to_25_mm__c,ETT_Number_of_cuts_26_to_38_mm__c,ETT_Number_of_cuts_39_to_50_mm__c,ETT_Number_of_cuts_51_mm_and_above__c,
                                                         (select Id,Name,ETT_Cause_of_Rejection__c,ETT_Other_Comments__c,ETT_Recommendations__c,ETT_Status__c,ETT_Tyre_Rejection_Line_Item__c from Tyre_Rejection_Sub_Line_Items__r where ETT_Status__c!=null)
                                                         
                                                         from ETT_Tyre_Rejection_Line_Item__c where (ETT_Job_Card__c=:jobCardId OR ETT_Inspection_Card__c=:inspectionCardId) order by createdDate desc]){
                                           
             System.debug('tyreRejLine: '+tyreRejLine);
                                                             
             String stageName=(tyreRejLine.ETT_Inspection_Card__c!=null) ? 'Initial Inspection' : tyreRejLine.ETT_Job_Stage__c;
             Integer version=tyreRejLine.ETT_Version__c>0 ? Integer.ValueOf(tyreRejLine.ETT_Version__c) : 1;
                                                             
             JobCardHistoryWrapper stageHistory;
             if(tyreRejLine.ETT_Inspection_Card__c!=null){
                 if(!stageWithRevisionHistoryMap.containsKey(stageName)){
                     stageWithRevisionHistoryMap.put(stageName,new Map<Integer,StageRevisionHistoryWrapper>{version=>new StageRevisionHistoryWrapper()});
                 }
                 if(!stageHistoryMap.containsKey(stageName)){
                     stageHistoryMap.put(stageName,new Map<Integer,JobCardHistoryWrapper>{version=>new JobCardHistoryWrapper()});      
                 }
                 stageHistory=stageHistoryMap.get(stageName).get(version);   
                 stageHistory.stageName=stageName;
                 stageHistory.jobCardId=jobCardId;
                 stageHistory.stageStartTime=tyreRejLine.ETT_Inspection_Card__r.ETT_Start_Time__c;
                 stageHistory.stageEndTime=tyreRejLine.ETT_Inspection_Card__r.ETT_End_Time__c;
                 stageHistory.versionNumber=1;
                 stageHistory.stageStatus='Accepted';
             } 
             else if(tyreRejLine.ETT_Job_Card__c!=null){
                 if(!stageWithRevisionHistoryMap.containsKey(stageName)){
                     stageWithRevisionHistoryMap.put(stageName,new Map<Integer,StageRevisionHistoryWrapper>());
                 }
                 if(!stageHistoryMap.containsKey(stageName)){
                     stageHistoryMap.put(stageName,new Map<Integer,JobCardHistoryWrapper>());      
                 }
                 if(!stageHistoryMap.get(stageName).containsKey(version)){
                     stageHistoryMap.get(stageName).put(version,new JobCardHistoryWrapper());      
                 }
                 
                 System.debug('stageWithRevisionHistoryMap: '+stageWithRevisionHistoryMap);
                 System.debug('stageHistoryMap: '+stageHistoryMap);
                 
                 stageHistory=stageHistoryMap.get(stageName).get(version);   
                 stageHistory.stageName=stageName;
                 stageHistory.jobCardId=jobCardId;
                 
                 System.debug('stageHistory: '+stageHistory);

                 if(stageHistory.stageName=='Buffing'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Buffing_Start_Time_new__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Buffing_End_time_new__c;
                     stageHistory.versionNumber=version;
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Buffing_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Buffing_Technician_Rejection_Remarks__c;
                     stageHistory.defectsStr='';//for buffing defects not applicable.
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Buffing_Rejection_Manager_Remarks__c;
                 }
                 else if(stageHistory.stageName=='Skiving'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Skiving_Start_time_new__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Skiving_End_time_new__c;
                     stageHistory.versionNumber=version; //Integer.ValueOf(tyreRejLine.ETT_Job_Card__r.ETT_No_of_Skiving_revisions__c);
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Skiving_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Skiving_Technician_Rejection_Remarks__c;
                     stageHistory.defectsStr=tyreRejLine.ETT_Job_Card__r.ETT_Skiving_Rework_Reason_s__c;
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Skiving_Rejection_Manager_Remarks__c;
                 } 
                 else if(stageHistory.stageName=='Repair'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Repair_Start_Time_new__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Repair_End_Time_new__c;
                     stageHistory.versionNumber=version;
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Repair_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Repair_Technician_Rejection_Remarks__c;
                     stageHistory.defectsStr=tyreRejLine.ETT_Job_Card__r.ETT_Repair_Rework_Reason_s__c;
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Repair_Rejection_Manager_Remarks__c;
                 } 
                 else if(stageHistory.stageName=='Cementing'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Cementing_Start_time_new__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Cementing_End_Time_new__c;
                     stageHistory.versionNumber=version;
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Cementing_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Cementing_Technici_Rejection_Remarks__c;
                     stageHistory.defectsStr=tyreRejLine.ETT_Job_Card__r.ETT_Defect_s_Identified_On_Cementing__c;
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Cementing_Rejection_Manager_Remarks__c;
                 } 
                 else if(stageHistory.stageName=='Filling'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Filling_Start_Time_new__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Filling_End_Time_new__c;
                     stageHistory.versionNumber=version;
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Filling_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Filling_Technician_Rejection_Remarks__c;
                     stageHistory.defectsStr=tyreRejLine.ETT_Job_Card__r.ETT_Defect_s_Identified_On_Filling__c;
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Filling_Rejection_Manager_Remarks__c;
                 } 
                 else if(stageHistory.stageName=='Thread Preparation'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Thread_Prep_Start_Time__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Thread_Prep_End_Time__c;
                     stageHistory.versionNumber=version;
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Thread_Preparation_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Thread_Technician_Rejection_Remarks__c;
                     stageHistory.defectsStr='';//not applicable for thread stage
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Thread_Rejection_Manager_Remarks__c;
                 } 
                 else if(stageHistory.stageName=='Building'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Building_Start_Time_new__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Building_End_Time_new__c;
                     stageHistory.versionNumber=version;
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Building_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Building_Technician_Reject_Remarks__c;
                     stageHistory.defectsStr=tyreRejLine.ETT_Job_Card__r.ETT_Defect_s_Identified_On_Building__c;
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Building_Rejection_Manager_Remarks__c;
                 } 
                 else if(stageHistory.stageName=='Rimming & Enveloping'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Rimming_Env_Start_Time__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Rimming_Env_End_Time__c;
                     stageHistory.versionNumber=version;
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Rimming_Env_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Rimming_Env_Technician_Reject_Remark__c;
                     stageHistory.defectsStr=tyreRejLine.ETT_Job_Card__r.ETT_Defect_s_Identified_On_Rimming_Env__c;
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Rimming_Env_Manager_Remarks__c;
                 } 
                 else if(stageHistory.stageName=='Curing'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Curing_Start_Time_new__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Curing_End_Time_new__c;
                     stageHistory.versionNumber=version;
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Curing_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Curing_Technician_Rejection_Remarks__c;
                     stageHistory.defectsStr=tyreRejLine.ETT_Job_Card__r.ETT_Defect_s_Identified_On_Curing__c;
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Curing_Rejection_Manager_Remarks__c;
                 } 
                 else if(stageHistory.stageName=='Final Inspection'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Final_Inspection_Start_Time_new__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Final_Inspection_End_Time_new__c;
                     stageHistory.versionNumber=version;
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Final_Inspection_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Final_Inspection_Technician_Remarks__c;
                     stageHistory.defectsStr=tyreRejLine.ETT_Job_Card__r.ETT_Defect_Identified_Final_Inspection__c;
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Final_Inspection_Manager_Remarks__c;
                 } 
                 else if(stageHistory.stageName=='Painting'){
                     stageHistory.stageStartTime=tyreRejLine.ETT_Job_Card__r.ETT_Painting_Start_Time_new__c;
                     stageHistory.stageEndTime=tyreRejLine.ETT_Job_Card__r.ETT_Painting_End_Time_new__c;
                     stageHistory.versionNumber=version;
                     stageHistory.stageStatus=tyreRejLine.ETT_Job_Card__r.ETT_Painting_Status__c;
                     stageHistory.techRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Painting_Technician_Remarks__c;
                     stageHistory.defectsStr=tyreRejLine.ETT_Job_Card__r.ETT_Defect_s_Identified_On_Painting__c;
                     stageHistory.managerRemarks=tyreRejLine.ETT_Job_Card__r.ETT_Painting_Manager_Remarks__c;
                 } 
             } 
             
             System.debug('stageName: '+stageName);
             System.debug('version: '+version);
             //System.debug(stageWithRevisionHistoryMap.get(stageName).containsKey(version)); 
                             
                                                             if(stageName!=null){
             if(!stageWithRevisionHistoryMap.get(stageName).containsKey(version)){
                 System.debug('inside if');
                 stageWithRevisionHistoryMap.get(stageName).put(version,new StageRevisionHistoryWrapper());
             }
                                                                 
             StageRevisionHistoryWrapper stageWrap=stageWithRevisionHistoryMap.get(stageName).get(version);
             stageWrap.revisionNumber=version;
             
             ETT_TyreInspectionCardWrapper.TyreRejectionLineItem newLine=new ETT_TyreInspectionCardWrapper.TyreRejectionLineItem();
             newLine.tyreRejectionName=tyreRejLine.Name;
             newLine.goodCondition=tyreRejLine.ETT_Good_Condition__c;
             newLine.recordId=tyreRejLine.Id; 
             
             if(tyreRejLine.ETT_Number_of_cuts_0_10_mm__c>0){
                 ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper fileInd=new ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper();
                 fileInd.label='Cuts (0 to 10mm)';
                 fileInd.selectedValue=String.ValueOf(tyreRejLine.ETT_Number_of_cuts_0_10_mm__c);
                 fileInd.file=new List<ETT_TyreInspectionCardWrapper.FileWrapperNTC>();
                 ETT_TyreInspectionCardWrapper.FileWrapperNTC indFileImage=new ETT_TyreInspectionCardWrapper.FileWrapperNTC();
                 fileInd.file.add(indFileImage);
                 
                 newLine.cuts_0_to_10=new List<ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper>();
                 newLine.cuts_0_to_10.add(fileInd);                     
             }
             
             if(tyreRejLine.ETT_Number_of_cuts_11_to_25_mm__c>0){
                 ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper fileInd=new ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper();
                 fileInd.label='Cuts (11 to 25mm)';
                 fileInd.selectedValue=String.ValueOf(tyreRejLine.ETT_Number_of_cuts_11_to_25_mm__c);
                 fileInd.file=new List<ETT_TyreInspectionCardWrapper.FileWrapperNTC>();
                 ETT_TyreInspectionCardWrapper.FileWrapperNTC indFileImage=new ETT_TyreInspectionCardWrapper.FileWrapperNTC();
                 fileInd.file.add(indFileImage);
                 
                 newLine.cuts_11_to_25=new List<ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper>();
                 newLine.cuts_11_to_25.add(fileInd); 
             }
             
             if(tyreRejLine.ETT_Number_of_cuts_26_to_38_mm__c>0){
                 ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper fileInd=new ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper();
                 fileInd.label='Cuts (26 to 38mm)';
                 fileInd.selectedValue=String.ValueOf(tyreRejLine.ETT_Number_of_cuts_26_to_38_mm__c);
                 fileInd.file=new List<ETT_TyreInspectionCardWrapper.FileWrapperNTC>();
                 ETT_TyreInspectionCardWrapper.FileWrapperNTC indFileImage=new ETT_TyreInspectionCardWrapper.FileWrapperNTC();
                 fileInd.file.add(indFileImage);
                 
                 newLine.cuts_26_to_38=new List<ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper>();
                 newLine.cuts_26_to_38.add(fileInd);
             }
             
             if(tyreRejLine.ETT_Number_of_cuts_39_to_50_mm__c>0){
                 ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper fileInd=new ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper();
                 fileInd.label='Cuts (39 to 50mm)';
                 fileInd.selectedValue=String.ValueOf(tyreRejLine.ETT_Number_of_cuts_39_to_50_mm__c);
                 fileInd.file=new List<ETT_TyreInspectionCardWrapper.FileWrapperNTC>();
                 ETT_TyreInspectionCardWrapper.FileWrapperNTC indFileImage=new ETT_TyreInspectionCardWrapper.FileWrapperNTC();
                 fileInd.file.add(indFileImage);
                 
                 newLine.cuts_39_to_50=new List<ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper>();
                 newLine.cuts_39_to_50.add(fileInd);
             }
             
             if(tyreRejLine.ETT_Number_of_cuts_51_mm_and_above__c>0){
                 ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper fileInd=new ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper();
                 fileInd.label='Cuts (51mm and above)';
                 fileInd.selectedValue=String.ValueOf(tyreRejLine.ETT_Number_of_cuts_51_mm_and_above__c);
                 fileInd.file=new List<ETT_TyreInspectionCardWrapper.FileWrapperNTC>();
                 ETT_TyreInspectionCardWrapper.FileWrapperNTC indFileImage=new ETT_TyreInspectionCardWrapper.FileWrapperNTC();
                 fileInd.file.add(indFileImage);
                 
                 newLine.cuts_51=new List<ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper>();
                 newLine.cuts_51.add(fileInd);
             }
             
             newLine.lstTyreRejectionSubLineItems=new list<ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem>();
             
             if(tyreRejLine.Tyre_Rejection_Sub_Line_Items__r!=null && tyreRejLine.Tyre_Rejection_Sub_Line_Items__r.size() >0){
                 for(ETT_Tyre_Rejection_Sub_Line_Item__c subItem:tyreRejLine.Tyre_Rejection_Sub_Line_Items__r){
                     ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem newSubItem=new ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem();
                     newSubItem.strRejectionName=subItem.name;
                     newSubItem.strCauseOfRejection=subItem.ETT_Cause_of_Rejection__c;
                     newSubItem.strRecommendations=subItem.ETT_Recommendations__c;
                     newSubItem.strOtherComments=subItem.ETT_Other_Comments__c;
                     newSubItem.strStatus=subItem.ETT_Status__c;
                     newSubItem.lstFileWrapperDetails=new List<ETT_TyreInspectionCardWrapper.FileWrapper>();
                     newSubItem.recordId=subItem.Id;
                     newLine.lstTyreRejectionSubLineItems.add(newSubItem);
                 }
             }
             stageWrap.complaintLists.add(newLine);
             stageWithRevisionHistoryMap.get(stageName).put(version,stageWrap);
                                                                 }
        }
        
        if(parentIdWithContentDocumentLinkMap.keyset() !=null && parentIdWithContentDocumentLinkMap.keyset().size()>0){
            for(ContentDocumentLink cv:[Select Id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId IN:parentIdWithContentDocumentLinkMap.keyset()]){
                if(!parentIdWithContentDocumentLinkMap.containsKey(cv.LinkedEntityId)){
                    parentIdWithContentDocumentLinkMap.put(cv.LinkedEntityId,new Map<Id,Id>());
                }
                parentIdWithContentDocumentLinkMap.get(cv.LinkedEntityId).put(cv.ContentDocumentId,cv.ContentDocumentId);
                contentDocumentIdWithVersionMap.put(cv.ContentDocumentId,null);
            }  
            for(ContentVersion v:[Select Id,ContentDocumentId,ContentUrl,Title from ContentVersion where isLatest=true and ContentDocumentId IN:contentDocumentIdWithVersionMap.keyset()]){
                contentDocumentIdWithVersionMap.put(v.ContentDocumentId,v);
            }   
        }
        
        if(stageWithRevisionHistoryMap.keyset()!=null && stageWithRevisionHistoryMap.keyset().size() >0){
            for(String stageStr:stageWithRevisionHistoryMap.keyset()){
                if(stageWithRevisionHistoryMap.get(stageStr)!=null && stageWithRevisionHistoryMap.get(stageStr).keyset()!=null){
                    List<Integer> revisions=new List<Integer>(stageWithRevisionHistoryMap.get(stageStr).keyset());
                    revisions.sort();
                    for(Integer i=(revisions.size()-1);i>=0;i--){
                        if(stageHistoryMap.containsKey(stageStr) && stageHistoryMap.get(stageStr)!=null && stageHistoryMap.get(stageStr).containsKey(revisions[i])){
                            JobCardHistoryWrapper jWrapper=stageHistoryMap.get(stageStr).get(revisions[i]);    
                            if(stageWithRevisionHistoryMap.get(stageStr).containsKey(revisions[i]) && stageWithRevisionHistoryMap.get(stageStr).get(revisions[i])!=null){
                                jWrapper.stageData=stageWithRevisionHistoryMap.get(stageStr).get(revisions[i]);
                                for(ETT_TyreInspectionCardWrapper.TyreRejectionLineItem line:jWrapper.stageData.complaintLists){
                                    if(line.lstTyreRejectionSubLineItems!=null){
                                        for(ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem subLine:line.lstTyreRejectionSubLineItems){
                                            if(parentIdWithContentDocumentLinkMap.containsKey(subLine.recordId) && parentIdWithContentDocumentLinkMap.get(subLine.recordId)!=null){
                                                for(Id contentDocId:parentIdWithContentDocumentLinkMap.get(subLine.recordId).keyset()){
                                                    if(contentDocumentIdWithVersionMap.containsKey(contentDocId) && contentDocumentIdWithVersionMap.get(contentDocId)!=null){
                                                        ETT_TyreInspectionCardWrapper.FileWrapper fileWrap=new ETT_TyreInspectionCardWrapper.FileWrapper();
                                                        fileWrap.strFileName=contentDocumentIdWithVersionMap.get(contentDocId).Title;
                                                        fileWrap.fileContent=Label.ETT_ContentBaseURL+'/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+contentDocumentIdWithVersionMap.get(contentDocId).Id;
                                                        subLine.lstFileWrapperDetails.add(fileWrap);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if(parentIdWithContentDocumentLinkMap.containsKey(line.recordId) && parentIdWithContentDocumentLinkMap.get(line.recordId)!=null){
                                        for(Id contentDocId:parentIdWithContentDocumentLinkMap.get(line.recordId).keyset()){
                                            if(contentDocumentIdWithVersionMap.containsKey(contentDocId) && contentDocumentIdWithVersionMap.get(contentDocId)!=null){
                                                if(line.cuts_0_to_10!=null && line.cuts_0_to_10.size() >0 && line.cuts_0_to_10[0].file!=null && line.cuts_0_to_10[0].file.size() >0 && contentDocumentIdWithVersionMap.get(contentDocId).Title.startsWithIgnoreCase('Cuts_0_to_10mm')){
                                                    ETT_TyreInspectionCardWrapper.FileWrapperNTC fileIns=line.cuts_0_to_10[0].file[0]; 
                                                    fileIns.strFileName=contentDocumentIdWithVersionMap.get(contentDocId).Title;
                                                    fileIns.fileContent=Label.ETT_ContentBaseURL+'/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+contentDocumentIdWithVersionMap.get(contentDocId).Id;
                                                }
                                                else if(line.cuts_11_to_25!=null && line.cuts_11_to_25.size() >0 && line.cuts_11_to_25[0].file!=null && line.cuts_11_to_25[0].file.size() >0 && contentDocumentIdWithVersionMap.get(contentDocId).Title.startsWithIgnoreCase('Cuts_11_to_25mm')){
                                                    ETT_TyreInspectionCardWrapper.FileWrapperNTC fileIns=line.cuts_11_to_25[0].file[0]; 
                                                    fileIns.strFileName=contentDocumentIdWithVersionMap.get(contentDocId).Title;
                                                    fileIns.fileContent=Label.ETT_ContentBaseURL+'/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+contentDocumentIdWithVersionMap.get(contentDocId).Id;
                                                }
                                                else if(line.cuts_26_to_38!=null && line.cuts_26_to_38.size() >0 && line.cuts_26_to_38[0].file!=null && line.cuts_26_to_38[0].file.size() >0 && contentDocumentIdWithVersionMap.get(contentDocId).Title.startsWithIgnoreCase('Cuts_26_to_38mm')){
                                                    ETT_TyreInspectionCardWrapper.FileWrapperNTC fileIns=line.cuts_26_to_38[0].file[0]; 
                                                    fileIns.strFileName=contentDocumentIdWithVersionMap.get(contentDocId).Title;
                                                    fileIns.fileContent=Label.ETT_ContentBaseURL+'/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+contentDocumentIdWithVersionMap.get(contentDocId).Id;
                                                    
                                                }
                                                else if(line.cuts_39_to_50!=null && line.cuts_39_to_50.size() >0 && line.cuts_39_to_50[0].file!=null && line.cuts_39_to_50[0].file.size() >0 && contentDocumentIdWithVersionMap.get(contentDocId).Title.startsWithIgnoreCase('Cuts_39_to_50mm')){
                                                    ETT_TyreInspectionCardWrapper.FileWrapperNTC fileIns=line.cuts_39_to_50[0].file[0]; 
                                                    fileIns.strFileName=contentDocumentIdWithVersionMap.get(contentDocId).Title;
                                                    fileIns.fileContent=Label.ETT_ContentBaseURL+'/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+contentDocumentIdWithVersionMap.get(contentDocId).Id;
                                                }
                                                else if(line.cuts_51!=null && line.cuts_51.size() >0 && line.cuts_51[0].file!=null && line.cuts_51[0].file.size() >0 && contentDocumentIdWithVersionMap.get(contentDocId).Title.startsWithIgnoreCase('Cuts_51mm_and_above')){
                                                    ETT_TyreInspectionCardWrapper.FileWrapperNTC fileIns=line.cuts_51[0].file[0]; 
                                                    fileIns.strFileName=contentDocumentIdWithVersionMap.get(contentDocId).Title;
                                                    fileIns.fileContent=Label.ETT_ContentBaseURL+'/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId='+contentDocumentIdWithVersionMap.get(contentDocId).Id;
                                                }
                                            }
                                        }                                     
                                    }
                                }
                            }
                            historyList.add(jWrapper);
                        }                             
                    }
                }
            }                    
        }
        return historyList;
    }
    @AuraEnabled
    Public Static ETT_Job_Card__c getJobCardDetails(Id jobCardId){
              
        
        ETT_Job_Card__c jc = [select id,ETT_Stages__c,ETT_Job_Stages_to_Perform_Ordered__c,ETT_Buffing_Technician_Rejection_Remarks__c,ETT_Skiving_Technician_Rejection_Remarks__c,ETT_Repair_Technician_Rejection_Remarks__c,ETT_Cementing_Technici_Rejection_Remarks__c,ETT_Filling_Technician_Rejection_Remarks__c,ETT_Thread_Technician_Rejection_Remarks__c,ETT_Building_Technician_Reject_Remarks__c,
                              ETT_Rimming_Env_Technician_Reject_Remark__c,ETT_Curing_Technician_Rejection_Remarks__c,ETT_Final_Inspection_Technician_Remarks__c,ETT_Painting_Technician_Remarks__c from ETT_Job_Card__c where Id=:jobCardId ];
        
      
        return jc;
    }
}