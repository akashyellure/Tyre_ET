/***
 * Author: Janardhan
 * CreatedDate: 09/11/21
 * Desc:
 * Test Class: ETT_JobCardCloseCtrlTest
 * 
 * */

public class ETT_JobCardCloseCtrl {

    @AuraEnabled
    public static ETT_Job_Card__c getJobCardRealtedDetails(string jobCardId){
        
        return [Select Id,Name,ETT_Job_type_card__c,SubInventory__c,ETT_Overall_Status__c,ETT_Stages__c,ETT_Tyre_Master__c,ETT_Job_Type__c,ETT_Inspection_Card__c,ETT_Inspection_Card__r.ETT_Collection_Card__c,Collection_Card__r.ETT_Accounts__r.Name,Collection_Card__r.ETT_Accounts__r.Party_Type__c,ETT_Inspection_Card__r.ETT_Account__r.Name,ETT_Inspection_Card__r.ETT_Account__r.Party_Type__c,ETT_Inspection_Card__r.ETT_Collection_Card__r.ETT_Collection_Date__c,
                ETT_Inspection_Card__r.ETT_Brand__r.Name, ETT_Inspection_Card__r.ETT_Tyre_Size__r.Name,ETT_Inspection_Card__r.ETT_Tyre_Serial_Number__c,ETT_Inspection_Card__r.ETT_Account__c,ETT_Tyre_Master__r.ETT_Original_Pattern__r.Name,ETT_Tyre_Master__r.ETT_Ply_Rate__c,ETT_Tyre_Master__r.ETT_Load_Index__c,
                ETT_Tyre_Master__r.ETT_Speed_Index__c,ETT_Buffing_Technician_Rejection_Remarks__c,ETT_Building_Technician_Reject_Remarks__c,ETT_Cementing_Technici_Rejection_Remarks__c,ETT_Curing_Technician_Rejection_Remarks__c,ETT_Filling_Technician_Rejection_Remarks__c,ETT_Final_Inspection_Technician_Remarks__c,ETT_Painting_Technician_Remarks__c,Quality_control_Tech__c,ETT_Repair_Technician_Rejection_Remarks__c,ETT_Rimming_Env_Technician_Reject_Remark__c,ETT_Skiving_Technician_Rejection_Remarks__c,ETT_Thread_Technician_Rejection_Remarks__c from ETT_Job_Card__c where id=:jobCardId];
    }
    
    
    @AuraEnabled
    public static list<ETT_Job_Card_Line_Item__c> getCuringInfo(string jobCardId){
        return [select id,ETT_Curing_Round_Number__c,ETT_Curing_Start_Time__c,ETT_Curing_End_Time__c,Pressure_Valve__c,Vacuum_Valve__c from ETT_Job_Card_Line_Item__c where ETT_Job_Card__c=:jobCardId AND RecordType.Name='Curing' AND Sequence__c=2 order by ETT_Revision_Number__c DESC];
    } 
    @AuraEnabled
    public static list<ETT_Job_Card_Line_Item__c> getBuffingInfo(string jobCardId){
        return [select id, Desired_Tread_Pattern__c from ETT_Job_Card_Line_Item__c where ETT_Job_Card__c=:jobCardId AND RecordType.Name='Buffing' AND Sequence__c=7 order by ETT_Revision_Number__c DESC];
    } 
    @AuraEnabled
    public static list<ETT_Job_Card_Line_Item__c> getEnvelopeInfo(string jobCardId){
        return [select id,Pressure_Valve__c,Vacuum_Valve__c from ETT_Job_Card_Line_Item__c where ETT_Job_Card__c=:jobCardId AND RecordType.Name='Rimming & Enveloping' AND Sequence__c=9 order by ETT_Revision_Number__c DESC];
    }
    
    @AuraEnabled
    public static string getJobTypeValue(string insCardId){
        
        ETT_Inspection_Card__c ins = [select id,ETT_Tyre_Serial_Number__c,ETT_Collection_Card__c from ETT_Inspection_Card__c where id=:insCardId];
        
        WorkOrderLineItem workLine = [select id,ETT_Job_Type__c from WorkOrderLineItem where ETT_Tyre_Serial_Number__c=:ins.ETT_Tyre_Serial_Number__c AND ETT_Collection_Card__c=:ins.ETT_Collection_Card__c];
        
        return workLine.ETT_Job_Type__c;
    }
    
    @AuraEnabled
    public static List<String> getselectOptions(string objObject, string fld) { 
      
     List < String > allOpts = new list <String> ();
        
      DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objObject).getDescribe();
      DescribeFieldResult fieldResult = objResult.fields.getMap().get(fld).getDescribe();
     
        list < Schema.PicklistEntry > values =fieldResult.getPicklistValues();
      
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        //allOpts.sort();
      
        return allOpts;
    } 
    
     @AuraEnabled
    public static list<ETT_Tools_Material_Usage__c> getAllUsedItems(string JobCardId){
        
        return [select id,ETT_Job_Stage__c,ETT_Tools_Material_Allocation__c,ETT_Tools_Material_Allocation__r.ETT_Tools_Master__c,ETT_Usage_Value__c,ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Unique_Code__c,
                ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Individual_Unit_Value__c,ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Item_Description__c,ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.UOM__c,ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Main_Stock_Units__c from ETT_Tools_Material_Usage__c where ETT_Job_Card__c=:JobCardId ];
    }
    
      @AuraEnabled
    public static ETT_Tools_Master__c getToolMasterInfo(string toolMasId){
        return [SELECT Id,ETT_Unique_Code__c,ETT_Individual_Unit_Value__c,ETT_Item_Description__c,UOM__c,ETT_Main_Stock_Units__c from ETT_Tools_Master__c where id=:toolMasId];
    }
    
   @AuraEnabled
    public static void createJCcloseLinesUnderJC(list<ETT_Job_Card_Close_Lines__c> JCcloseLines,string JCCloseId){
        system.debug('--'+JCcloseLines);
        if(JCcloseLines!= null && JCcloseLines.size()>0){
            for(ETT_Job_Card_Close_Lines__c line :JCcloseLines){
                
                line.Job_Card_Close__c = JCCloseId;
            }
            
            
             try {
                 insert JCcloseLines;
             }
            catch (Exception e) {
                
                throw new AuraHandledException(e.getMessage());    
            }
        }
       
    }

}