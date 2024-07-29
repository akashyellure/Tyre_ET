/*
Created Date:3/4/2020
Created  By :G.Krishnareddy
Description :This is auto Create Collection Appointment for Assigned Service resources.
*/
public class ETT_ErrorhandlingProcess {
    
    //Error Handling Exception records
    public static list<ETT_Apex_Error_log__c> errorHandlingProcess(string strRecordId,list<Database.Error> lstErrorInfo,string strClassName){
        list<ETT_Apex_Error_log__c> lstETTErrorLog = new list<ETT_Apex_Error_log__c>();
        
        for(Database.Error err : lstErrorInfo) {
                                ETT_Apex_Error_log__c objErrorLog =  new ETT_Apex_Error_log__c(); 
                                objErrorLog.ETT_Error_Message__c = err.getStatusCode() + ': ' + err.getMessage()+' '+ETT_ConstantCls.strFailure + err.getFields();
                                objErrorLog.ETT_Class__c = strClassName;
                                objErrorLog.ETT_S_Object_Id__c    = strRecordId;
                                objErrorLog.ETT_Line_Number__c    = string.valueOf(err.getFields());
                                objErrorLog.ETT_Log_Time__c       = Datetime.now();
                                lstETTErrorLog.add(objErrorLog);
        }
        
        if(lstETTErrorLog!=null && lstETTErrorLog.size()>0){
            return lstETTErrorLog;
        }else{
            return null;
        }
    }
}