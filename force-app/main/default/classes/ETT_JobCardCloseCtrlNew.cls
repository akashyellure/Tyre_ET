/***
 * Desc:
 * Test Class: ETT_JobCardCloseCtrlNewTest
 * 
 * */

public class ETT_JobCardCloseCtrlNew {

    @AuraEnabled
    public static Map<string,object>  getJobCardRealtedDetails(string jobCardId){
        
        List<ETT_Job_Card__c> lstJob= [Select Party_Code__c,Store_Code__c,ETT_job_type_card__c,SubInventory__c,Sub_Inventory__c,ETT_Curing_Round_Number__c,Tyre_Inventory__r.ETT_Brand__r.Name,ETT_Curing_Start_Time__c,ETT_Tread_Width__c,ETT_Tread_Length__c,Created_Date__c,ETT_Inspection_Card__r.Tyre_Life__c,Customer__r.Name,Customer_Type__c,ETT_Inspection_Card__r.Country__c,Id,Name,ETT_Overall_Status__c,ETT_Stages__c,ETT_Tyre_Master__c,ETT_Job_Type__c
                                       ,ETT_Inspection_Card__c,ETT_Inspection_Card__r.ETT_Collection_Card__c,Collection_Card__r.ETT_Accounts__r.Name,Collection_Card__r.ETT_Accounts__r.Party_Type__c,ETT_Inspection_Card__r.ETT_Account__r.Name,ETT_Inspection_Card__r.ETT_Account__r.Party_Type__c,ETT_Inspection_Card__r.ETT_Collection_Card__r.ETT_Collection_Date__c,
                                       Job_Card_Status__c,Open_Date__c,
                                       Close_Date__c,ETT_Inspection_Card__r.ETT_Brand__r.Name,ETT_Inspection_Card__r.Brand__c, ETT_Inspection_Card__r.Tyre_Size__c,
                                       ETT_Inspection_Card__r.ETT_Tyre_Serial_Number__c,ETT_Inspection_Card__r.ETT_Account__c,ETT_Tyre_Master__r.ETT_Original_Pattern__r.Name,ETT_Inspection_Card__r.Pattern__c,ETT_Tyre_Master__r.ETT_Ply_Rate__c,ETT_Tyre_Master__r.ETT_Load_Index__c,
                                       ETT_Tyre_Master__r.ETT_Speed_Index__c,
                                       ETT_Buffing_Technician_Rejection_Remarks__c,
                                       ETT_Building_Technician_Reject_Remarks__c,ETT_Cementing_Technici_Rejection_Remarks__c,ETT_Curing_Technician_Rejection_Remarks__c,ETT_Filling_Technician_Rejection_Remarks__c,ETT_Final_Inspection_Technician_Remarks__c,
                                       ETT_Painting_Technician_Remarks__c,Quality_control_Tech__c,ETT_Repair_Technician_Rejection_Remarks__c,ETT_Rimming_Env_Technician_Reject_Remark__c,ETT_Skiving_Technician_Rejection_Remarks__c,ETT_Thread_Technician_Rejection_Remarks__c,
                                       Tyre_Inventory__r.ETT_Tyre_Master__r.ETT_Ply_Rate__c,Tyre_Inventory__r.ETT_Tyre_Master__r.ETT_Speed_Index__c,Tyre_Inventory__r.ETT_Tyre_Master__r.ETT_Load_Index__c,Tyre_Inventory__r.ETT_Tyre_Master__r.ETT_Original_Pattern__r.Name,Tyre_Inventory__r.ETT_Tyre_Master__r.ETT_Tyre_Size__r.Name
                                       
                                       from ETT_Job_Card__c where id=:jobCardId];
        system.debug('lstJob'+lstJob);
        Decimal crownCut;
        String sidewallcut;
        Map<string,object> mapreturn =new Map<string,object>();
        List<ETT_Tyre_Rejection_Line_Item__c>      sidewallcuts = new List<ETT_Tyre_Rejection_Line_Item__c>();
        
        sidewallcuts =[Select Name,Cut__c,Crown_Cuts__c,ETT_Inspection_Card__c from ETT_Tyre_Rejection_Line_Item__c where (Name ='SideWallArea' or Name ='CrownArea') and ETT_Inspection_Card__c=:lstJob[0].ETT_Inspection_Card__c];
        system.debug('sidewallcuts'+sidewallcuts);
        mapreturn.put('lstJob',lstJob[0]);
        if(sidewallcuts.size()>0){
            for(ETT_Tyre_Rejection_Line_Item__c TRlineitem : sidewallcuts){
                if(TRlineitem.Name =='SideWallArea'){
                    sidewallcut = TRlineitem.Cut__c;    
                }
                else if(TRlineitem.Name =='CrownArea'){
                    crownCut = TRlineitem.Crown_Cuts__c;    
                } 
            }
            
        }
        
        mapreturn.put('sidewallcut',sidewallcut);
        mapreturn.put('crownCut',crownCut);
        return mapreturn;
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
    public static ETT_Tyre_Employee_Master__c getEmployeeMasterDetails(string recordId){
        
        return [select Name,Employee_Name__c from ETT_Tyre_Employee_Master__c  where id=:recordId ];
    }
    
     @AuraEnabled
    public static list<ETT_Tools_Material_Usage__c> getAllUsedItems(string JobCardId){
        
        return [select id,ETT_Job_Stage__c,ETT_Tools_Material_Allocation__c,ETT_Tools_Material_Allocation__r.ETT_Tools_Master__c,ETT_Usage_Value__c,ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Unique_Code__c,
                ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Individual_Unit_Value__c,ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Item_Description__c,ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.UOM__c,ETT_Tools_Material_Allocation__r.ETT_Tools_Master__r.ETT_Main_Stock_Units__c from ETT_Tools_Material_Usage__c where ETT_Job_Card__c=:JobCardId ];
    }
    
    @AuraEnabled
    public static list<ETT_JCC_Employee__c> getAllEmployees(string JobCardId){
        
        return [select id, ETT_Job_Type__c, ETT_Emp_No__c, ETT_Employee_Name__c, ETT_Working_Date__c, ETT_Start_Time__c, 
                ETT_End_Time__c, ETT_Job_Card__c 
                FROM ETT_JCC_Employee__c where ETT_Job_Card__c=:JobCardId];
    }
    
      @AuraEnabled
    public static ETT_Tools_Master__c getToolMasterInfo(string toolMasId){
        return [SELECT Id,ETT_Allocated_Units__c,ETT_Unique_Code__c,ETT_Individual_Unit_Value__c,ETT_Item_Description__c,UOM__c,ETT_Main_Stock_Units__c from ETT_Tools_Master__c where id=:toolMasId];
    }
     @AuraEnabled
    public static ETT_Tyre_Employee_Master__c getTyreEmployeeMasterInfo(string EmpId){
        return [SELECT Id,Name,Employee_Name__c FROM ETT_Tyre_Employee_Master__c where id=:EmpId];
    }
    
   	@AuraEnabled
    public static void createJCcloseLinesUnderJC(list<ETT_Job_Card_Close_Lines__c> JCcloseLines,string JCCloseId, list<ETT_JCC_Employee__c> JCcloseEmployees, ETT_JCC_Rejection_Analysis__c jccRejection, ETT_Job_Card__c jobCardInfo){
       /* system.debug('JobCardInfo=='+jobCardInfo);
        system.debug('jccRejection'+jccRejection);
        system.debug('JCCloseId'+JCCloseId);
        system.debug('JCcloseLines=='+JCcloseLines);
*/
        Map<string,Decimal> mapETTToolsMaster=new Map<string,Decimal>(); 
        try{
            if(JCcloseLines!= null && JCcloseLines.size()>0){
                List<ETT_Job_Card_Close_Lines__c> jccLines = new List<ETT_Job_Card_Close_Lines__c>();
                for(ETT_Job_Card_Close_Lines__c line : JCcloseLines){
                    //System.debug('line save'+line);
                    if(!String.isBlank(line.ETT_Unique_Code__c) || !String.isBlank(line.ETT_Item_Description__c)){
                        line.Job_Card_Close__c = JCCloseId;
                        jccLines.add(line);
                        
                       Decimal itemData= mapETTToolsMaster.get(line.Item_Name__c);
                        if(itemData==null)
                            itemData=0;
                        if(line.Issued_Quantity__c==null)
                            line.Issued_Quantity__c=0;
                        
                        mapETTToolsMaster.put(line.Item_Name__c,itemData+line.Issued_Quantity__c);
                    }
                }
                insert jccLines;
            }
            
            List<ETT_Tools_Master__c> lstETTToolsMaster=new List<ETT_Tools_Master__c>();
            lstETTToolsMaster=[select id,ETT_Main_Stock_Units__c from ETT_Tools_Master__c where id in: mapETTToolsMaster.keyset()];
            for(ETT_Tools_Master__c et:lstETTToolsMaster){
               // et.ETT_Main_Stock_Units__c=et.ETT_Main_Stock_Units__c-mapETTToolsMaster.get(et.Id);
            }
            
            if(lstETTToolsMaster.size()>0)
                update lstETTToolsMaster;

            
            if(JCCloseId != null && !JCcloseEmployees.isEmpty()){
                List<ETT_JCC_Employee__c> jccEmployees = new List<ETT_JCC_Employee__c>();
                for(ETT_JCC_Employee__c emp :JCcloseEmployees){
                  //  System.debug('emp save'+emp);
                    if(emp.ETT_Emp_No__c != null || !String.isBlank(emp.ETT_Employee_Name__c)){
                    	emp.ETT_Job_Card_Close__c = JCCloseId;
                        jccEmployees.add(emp);
                    }
                }
                insert JCcloseEmployees;
            }
            System.debug('jccRejection '+jccRejection);
            if(jccRejection != null && JCCloseId != null){
                jccRejection.ETT_Job_Card_Close__c = JCCloseId;
                insert jccRejection;
            }
            
            if(jobCardInfo != null){
                update jobCardInfo;
            }
            ETT_Job_Card_Close__c et=new ETT_Job_Card_Close__c();
            et.Id=JCCloseId;
            et.Party__c=jobCardInfo.Customer__c;
            update et;
            
            
            
            
        }
        catch (Exception e) {
            system.debug('error==='+e.getMessage());
            throw new AuraHandledException(e.getMessage());    
        }
    }

}