/**
 * Author:Janardhan
 * CreatedDate:14/12/2021
 * TestClass: ETT_TyreWorkStationHomeCtrlTest
 * */
public class ETT_TyreWorkStationHomeCtrl {
    
    @auraEnabled
    public static user getUserDetails(){
        
        return [select id,FirstName,LastName from user where Id=:userInfo.getUserId()];
    }
    
    @auraEnabled
    public static ETT_Work_Schedule__c getWorkscheduleInfo(){
        
        list<ETT_Work_Schedule__c> workSchList = [Select Id,Name,ETT_Technician__c,ETT_Technician__r.Name,ETT_Work_Station__c,ETT_Work_Station__r.ETT_Station_Code__c,ETT_Work_Station__r.Name,ETT_Work_Station__r.ETT_Station_Type__c from ETT_Work_Schedule__c where
                                                  ETT_Technician__c=:Userinfo.getUserId() and ETT_End_time__c>=:System.NOW() AND ETT_Start_time__c<=:System.NOW()];
        
        if(workSchList.size()>0){
            return workSchList[0];
        }else{
            return null;
        }
    }
      @auraEnabled
    public static list<ETT_Job_Card__c> getJobCardsInfo(){
        
        list<ETT_Work_Schedule__c> workSchList = [Select Id,Name,ETT_Technician__c,ETT_Technician__r.Name,ETT_Work_Station__c,ETT_Work_Station__r.ETT_Station_Code__c,ETT_Work_Station__r.Name,ETT_Work_Station__r.ETT_Station_Type__c from ETT_Work_Schedule__c where
                                                  ETT_Technician__c=:Userinfo.getUserId() and ETT_End_time__c>=:System.NOW() AND ETT_Start_time__c<=:System.NOW()];
        
        if(workSchList.size()>0){
            
            if(workSchList[0].ETT_Work_Station__r.ETT_Station_Type__c=='Filling'){
                //Show records only if Filling Summer halt time greaterthan 25 min/Winter 30 mins
                return [select id,Name,ETT_Previous_Job_Stage__c,Tyre_Inventory__c,createdDate,ETT_Priority__c,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.ETT_Pattern__r.Name from ETT_Job_Card__c where ETT_Stages__c=:workSchList[0].ETT_Work_Station__r.ETT_Station_Type__c AND Tyre_Inventory__c != null AND ETT_Overall_Status__c!='Rejected' AND (Filling_Summer_Halt_Time__c > 25 OR Filling_Winter_Halt_Time__c > 30) Order by ETT_Priority__c DESC];
                
            }else if(workSchList[0].ETT_Work_Station__r.ETT_Station_Type__c=='Building'){
                //Show records only if building halt time greaterthan 15 min
                return [select id,Name,ETT_Previous_Job_Stage__c,Tyre_Inventory__c,createdDate,ETT_Priority__c,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.ETT_Pattern__r.Name from ETT_Job_Card__c where ETT_Stages__c=:workSchList[0].ETT_Work_Station__r.ETT_Station_Type__c AND Tyre_Inventory__c != null AND ETT_Overall_Status__c!='Rejected' AND Building_Halt_Time__c>15 Order by ETT_Priority__c DESC];
                
            }else if(workSchList[0].ETT_Work_Station__r.ETT_Station_Type__c=='Thread Preparation'){
                
                 return [select id,Name,ETT_Previous_Job_Stage__c,ETT_Main_Job_Card__r.Name,Tyre_Inventory__c,createdDate,ETT_Priority__c,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.ETT_Pattern__r.Name from ETT_Job_Card__c where ETT_Stages__c=:workSchList[0].ETT_Work_Station__r.ETT_Station_Type__c AND ETT_Main_Job_Card__c!=null AND Tyre_Inventory__c != null AND ETT_Overall_Status__c!='Rejected' AND ETT_Thread_Preparation_Status__c!='Accepted'  Order by ETT_Priority__c DESC];
                
            }else {
                
                return [select id,Name,ETT_Previous_Job_Stage__c,Tyre_Inventory__c,createdDate,ETT_Priority__c,Tyre_Inventory__r.Serial_Number__c,Tyre_Inventory__r.ETT_Tyre_Size_Master__r.Name,Tyre_Inventory__r.ETT_Pattern__r.Name from ETT_Job_Card__c where ETT_Stages__c=:workSchList[0].ETT_Work_Station__r.ETT_Station_Type__c AND Tyre_Inventory__c != null AND (ETT_Overall_Status__c!='Rejected' AND ETT_Overall_Status__c!='Accepted') Order by ETT_Priority__c DESC];
                
            }
        }else{
            return null;
        }

       
    }
   	@auraEnabled
    public static void createWorkStationCheckList(ETT_Work_Station_Checklist__c wscl){
        
        try{
            insert wscl;
        }catch(Exception e) {
            system.debug('----'+e.getMessage());
            system.debug('----'+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());    
        }
    }
    @auraEnabled
    public static list<ETT_Work_Station_Checklist__c> getWorkStatCheckListDetails(){
        
      list<ETT_Work_Schedule__c> workSchList = [Select Id,Name,ETT_Technician__c,ETT_Technician__r.Name,ETT_Work_Station__c,ETT_Work_Station__r.ETT_Station_Code__c,ETT_Work_Station__r.Name,ETT_Work_Station__r.ETT_Station_Type__c from ETT_Work_Schedule__c where
                                                  ETT_Technician__c=:Userinfo.getUserId() and ETT_End_time__c>=:System.NOW() AND ETT_Start_time__c<=:System.NOW()];
        
        if(workSchList.size()>0){
          
            return [select Id,Name from ETT_Work_Station_Checklist__c where Work_Station__c=:workSchList[0].ETT_Work_Station__c AND Station_Type__c=:workSchList[0].ETT_Work_Station__r.Name and CreatedDate= TODAY];
        }else{
            
             return null;
        }
        
       
    }

}