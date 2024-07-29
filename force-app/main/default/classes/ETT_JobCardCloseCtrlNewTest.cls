@isTest
public class ETT_JobCardCloseCtrlNewTest {
    @isTest
static void jobcardCloseNew(){
   
    
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Tyre Customer');
        insert accountsList;
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(accountsList[0].Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
    
        List<ETT_Inspection_Card__c> inspectionList = new List<ETT_Inspection_Card__c>();
        ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
        ic.ETT_Tyre_Serial_Number__c = '89383';
        ic.ETT_Collection_Card__c=collectionCardsList[0].Id;
        insert ic;
        inspectionList.add(ic);
        //insert inspectionList;
          
        ETT_Job_Card__c jb = new ETT_Job_Card__c();
        jb.Job_Card_Status__c ='In Progress';
        jb.ETT_Inspection_Card__c = ic.id;
        insert jb;
        
        ETT_Job_Card_Close__c jc = new ETT_Job_Card_Close__c();
        jc.Status__c = 'New';
        jc.Job_Card__c=jb.Id;        
        insert jc;
        
        ETT_Job_Card_Close_Lines__c jcl = new ETT_Job_Card_Close_Lines__c();
        jcl.Available_Quantity__c =23;
        jcl.Job_Card_Close__c=jc.Id;
        //jcl.ETT_Unique_Code__c = '113';
        insert jcl;
        List <ETT_Job_Card_Close_Lines__c> Jobcardcloseline = New List <ETT_Job_Card_Close_Lines__c>();
        Jobcardcloseline.add(jcl);
        
        /*List<ETT_Inspection_Card__c> inspectionList = new List<ETT_Inspection_Card__c>();
        ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
        ic.ETT_Tyre_Serial_Number__c = '89383';
        ic.ETT_Collection_Card__c=collectionCardsList[0].Id;
        inspectionList.add(ic);
        insert inspectionList;*/
    
        
        //WorkOrderLineItem wol  = new WorkOrderLineItem();
       
        
        ETT_Tools_Master__c  tool = new ETT_Tools_Master__c();
        tool.Name='Test';
        
        insert tool;
        
        ETT_Job_Card_Line_Item__c  jobCardLI = new ETT_Job_Card_Line_Item__c();
        jobCardLI.ETT_Job_Card__c = jb.id; 
        jobCardLI.ETT_Activity_Performed__c = 'Check Tube Flap and Envelop';
        jobCardLI.ETT_Type__c = 'Pause';
        jobCardLI.Sequence__c = 2;
        insert jobCardLI;
   
        WorkOrder workord = New WorkOrder();
        workord.AccountId = accountsList[0].id;
        insert workord;
       WorkOrderLineItem Lineitem = New WorkOrderLineItem();
        Lineitem.ETT_Tyre_Serial_Number__c = ic.ETT_Tyre_Serial_Number__c;
        Lineitem.ETT_Collection_Card__c = ic.ETT_Collection_Card__c;
        Lineitem.ETT_Job_Type__c = 'Retread';
        Lineitem.WorkOrderId = workord.id;
        insert Lineitem;
    
        ETT_Tyre_Employee_Master__c ETemployee = New ETT_Tyre_Employee_Master__c();
        ETemployee.Employee_Name__c = 'Test';
        insert ETemployee;
    
        ETT_JCC_Employee__c JcEmployee = New ETT_JCC_Employee__c();
        JcEmployee.ETT_Employee_Name__c = 'Test';
        JcEmployee.ETT_Job_Card__c = jb.id;
        JcEmployee.ETT_Job_Card_Close__c = jc.id;
        insert JcEmployee;
    
        list<ETT_JCC_Employee__c> JcemployeeList = New list<ETT_JCC_Employee__c>();
        JcemployeeList.add(JcEmployee);
        
        ETT_JCC_Rejection_Analysis__c JcRejection = New ETT_JCC_Rejection_Analysis__c();
        JcRejection.ETT_Job_Card_Close__c = jc.id;
        insert JcRejection;
        
        ETT_Tyre_Rejection_Line_Item__c Tyrerejection = New ETT_Tyre_Rejection_Line_Item__c();
        Tyrerejection.Cut__c = 'Test12';
        //Tyrerejection.Crown_Cuts__c = 'test12';
        Tyrerejection.Name = 'SideWallArea';
        Tyrerejection.ETT_Inspection_Card__c = inspectionList[0].id;
        insert Tyrerejection;
        
               
        ETT_JobCardCloseCtrlNew.getJobCardRealtedDetails(jb.Id);
        ETT_JobCardCloseCtrlNew.getselectOptions('ETT_Job_Card_Close_Lines__c','Job_Type__c');
        ETT_JobCardCloseCtrlNew.getBuffingInfo(jb.id);
        //ETT_JobCardCloseCtrlNew.createJCcloseLinesUnderJC(new list<ETT_Job_Card_Close_Lines__c>{new ETT_Job_Card_Close_Lines__c()},jc.Id);
        ETT_JobCardCloseCtrlNew.getAllUsedItems(jb.Id);
        ETT_JobCardCloseCtrlNew.getToolMasterInfo(tool.Id);
        ETT_JobCardCloseCtrlNew.getCuringInfo(jb.Id);
        ETT_JobCardCloseCtrlNew.getEnvelopeInfo(jb.Id);
        ETT_JobCardCloseCtrlNew.getJobTypeValue(ic.id);
        ETT_JobCardCloseCtrlNew.getAllEmployees(jb.id);
        ETT_JobCardCloseCtrlNew.getTyreEmployeeMasterInfo(ETemployee.id);
    try{
        ETT_JobCardCloseCtrlNew.createJCcloseLinesUnderJC(Jobcardcloseline, jc.Id, JcemployeeList, JcRejection, jb);
    }catch(Exception e){}
    }
     @isTest
static void jobcardCloseNew2(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Tyre Customer');
        insert accountsList;
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(accountsList[0].Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
    
        List<ETT_Inspection_Card__c> inspectionList = new List<ETT_Inspection_Card__c>();
        ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
        ic.ETT_Tyre_Serial_Number__c = '89383';
        ic.ETT_Collection_Card__c=collectionCardsList[0].Id;
        insert ic;
        inspectionList.add(ic);
        //insert inspectionList;
          
        ETT_Job_Card__c jb = new ETT_Job_Card__c();
        jb.Job_Card_Status__c ='In Progress';
        jb.ETT_Inspection_Card__c = ic.id;
        insert jb;
        
        ETT_Job_Card_Close__c jc = new ETT_Job_Card_Close__c();
        jc.Status__c = 'New';
        jc.Job_Card__c=jb.Id;        
        insert jc;
    
       ETT_Tools_Master__c toolmaster = New ETT_Tools_Master__c();
        toolmaster.Name = 'Test';
        toolmaster.ETT_Main_Stock_Units__c = 2;
        insert toolmaster;
        
        ETT_Job_Card_Close_Lines__c jcl = new ETT_Job_Card_Close_Lines__c();
        jcl.Available_Quantity__c =23;
        jcl.Job_Card_Close__c=jc.Id;
        jcl.ETT_Unique_Code__c = '113';
        jcl.Item_Name__c = toolmaster.id;
        jcl.Issued_Quantity__c = null;
        insert jcl;
        List <ETT_Job_Card_Close_Lines__c> Jobcardcloseline = New List <ETT_Job_Card_Close_Lines__c>();
        Jobcardcloseline.add(jcl);
    
        
        /*List<ETT_Inspection_Card__c> inspectionList = new List<ETT_Inspection_Card__c>();
        ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
        ic.ETT_Tyre_Serial_Number__c = '89383';
        ic.ETT_Collection_Card__c=collectionCardsList[0].Id;
        inspectionList.add(ic);
        insert inspectionList;*/
    
        
        //WorkOrderLineItem wol  = new WorkOrderLineItem();
       
        
        
        /*WorkOrderLineItem Lineitem = New WorkOrderLineItem();
        Lineitem.ETT_Tyre_Serial_Number__c = ic.ETT_Tyre_Serial_Number__c;
        Lineitem.ETT_Collection_Card__c = ic.ETT_Collection_Card__c;
        Lineitem.ETT_Job_Type__c = 'Retread';
        insert Lineitem;*/
    
        ETT_JCC_Employee__c JcEmployee = New ETT_JCC_Employee__c();
        JcEmployee.ETT_Employee_Name__c = 'Test';
        JcEmployee.ETT_Job_Card__c = jb.id;
        JcEmployee.ETT_Job_Card_Close__c = jc.id;
        insert JcEmployee;
    
        list<ETT_JCC_Employee__c> JcemployeeList = New list<ETT_JCC_Employee__c>();
        JcemployeeList.add(JcEmployee);
        
        ETT_JCC_Rejection_Analysis__c JcRejection = New ETT_JCC_Rejection_Analysis__c();
        JcRejection.ETT_Job_Card_Close__c = jc.id;
        insert JcRejection;
        
        ETT_Tyre_Rejection_Line_Item__c Tyrerejection = New ETT_Tyre_Rejection_Line_Item__c();
        Tyrerejection.Cut__c = 'Test12';
        //Tyrerejection.Crown_Cuts__c = 'test12';
        Tyrerejection.Name = 'SideWallArea';
        Tyrerejection.ETT_Inspection_Card__c = inspectionList[0].id;
        insert Tyrerejection;
        
               
        ETT_JobCardCloseCtrlNew.getJobCardRealtedDetails(jb.Id);
        ETT_JobCardCloseCtrlNew.getselectOptions('ETT_Job_Card_Close_Lines__c','Job_Type__c');
        ETT_JobCardCloseCtrlNew.getBuffingInfo(jb.id);
        //ETT_JobCardCloseCtrlNew.createJCcloseLinesUnderJC(new list<ETT_Job_Card_Close_Lines__c>{new ETT_Job_Card_Close_Lines__c()},jc.Id);
        ETT_JobCardCloseCtrlNew.getAllUsedItems(jb.Id);
        ETT_JobCardCloseCtrlNew.getToolMasterInfo(toolmaster.Id);
        ETT_JobCardCloseCtrlNew.getCuringInfo(jb.Id);
        ETT_JobCardCloseCtrlNew.getEnvelopeInfo(jb.Id);
        //ETT_JobCardCloseCtrlNew.getJobTypeValue(ic.id);
        ETT_JobCardCloseCtrlNew.getAllEmployees(jb.id);
    try{
        ETT_JobCardCloseCtrlNew.createJCcloseLinesUnderJC(Jobcardcloseline, jc.Id, JcemployeeList, JcRejection, jb);
    }catch(Exception e){}
    }
    /*@isTest
    static void jobcardCloseNew1(){
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('TestAccountName', 'Tyre Customer');
        insert accountsList;
        
        Opportunity opp = ETT_TestFactory.createOpportunity('Tyre Supplier','TestOppName', 'Qualification', system.today().adddays(20), accountsList[0].Id);
        insert opp;
        
        
        List<ETT_Collection_Card__c> collectionCardsList = ETT_TestFactory.createCollectionCards(accountsList[0].Id,opp.Id);
        collectionCardsList[0].ETT_Inspection_Done__c = true;
        insert collectionCardsList;
    
        List<ETT_Inspection_Card__c> inspectionList = new List<ETT_Inspection_Card__c>();
        ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
        ic.ETT_Tyre_Serial_Number__c = '89383';
        ic.ETT_Collection_Card__c=collectionCardsList[0].Id;
        inspectionList.add(ic);
        insert inspectionList;
          
        ETT_Job_Card__c jb = new ETT_Job_Card__c();
        jb.Job_Card_Status__c ='In Progress';
        insert jb;
        
        ETT_Job_Card_Close__c jc = new ETT_Job_Card_Close__c();
        jc.Status__c = 'New';
        jc.Job_Card__c=jb.Id;        
        insert jc;
        
        ETT_Tools_Master__c toolmaster = New ETT_Tools_Master__c();
        toolmaster.Name = 'Test';
        toolmaster.ETT_Main_Stock_Units__c = 2;
        insert toolmaster;
        
        ETT_Job_Card_Close_Lines__c jcl = new ETT_Job_Card_Close_Lines__c();
        jcl.Available_Quantity__c =23;
        jcl.Job_Card_Close__c=jc.Id;
        jcl.ETT_Unique_Code__c = '113';
        jcl.Item_Name__c = toolmaster.id;
        jcl.Issued_Quantity__c = null;
        insert jcl;
        
        List <ETT_Job_Card_Close_Lines__c> Jobcardcloseline = New List <ETT_Job_Card_Close_Lines__c>();
        Jobcardcloseline.add(jcl);
        
        /*List<ETT_Inspection_Card__c> inspectionList = new List<ETT_Inspection_Card__c>();
        ETT_Inspection_Card__c ic = new ETT_Inspection_Card__c();
        ic.ETT_Tyre_Serial_Number__c = '89383';
        ic.ETT_Collection_Card__c=collectionCardsList[0].Id;
        inspectionList.add(ic);
        insert inspectionList;*/
    
        
        /*WorkOrderLineItem wol  = new WorkOrderLineItem();
       
        
        ETT_Tools_Master__c  tool = new ETT_Tools_Master__c();
        tool.Name='Test';
        
        insert tool;
        
        ETT_Job_Card_Line_Item__c  jobCardLI = new ETT_Job_Card_Line_Item__c();
        jobCardLI.ETT_Job_Card__c = jb.id; 
        jobCardLI.ETT_Activity_Performed__c = 'Check Tube Flap and Envelop';
        jobCardLI.ETT_Type__c = 'Pause';
        jobCardLI.Sequence__c = 2;
        insert jobCardLI;
    
        /*WorkOrderLineItem Lineitem = New WorkOrderLineItem();
        Id devRecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        Lineitem.RecordTypeId = devRecordTypeId;
        Lineitem.ETT_Tyre_Serial_Number__c = inspectionList[0].ETT_Tyre_Serial_Number__c;
        Lineitem.ETT_Collection_Card__c = collectionCardsList[0].Id;
        Lineitem.ETT_Job_Type__c = 'Retread';
        insert Lineitem;*/
        
       /* ETT_JCC_Employee__c JcEmployee = New ETT_JCC_Employee__c();
        JcEmployee.ETT_Employee_Name__c = 'Test';
        JcEmployee.ETT_Job_Card__c = jb.id;
        JcEmployee.ETT_Job_Card_Close__c = jc.id;
        insert JcEmployee;
    
        list<ETT_JCC_Employee__c> JcemployeeList = New list<ETT_JCC_Employee__c>();
        JcemployeeList.add(JcEmployee);
        
        ETT_JCC_Rejection_Analysis__c JcRejection = New ETT_JCC_Rejection_Analysis__c();
        JcRejection.ETT_Job_Card_Close__c = jc.id;
        insert JcRejection;
        
        ETT_Tyre_Rejection_Line_Item__c Tyrerejection = New ETT_Tyre_Rejection_Line_Item__c();
        Tyrerejection.Cut__c = 'Test12';
        //Tyrerejection.Crown_Cuts__c = 'test12';
        Tyrerejection.Name = 'CrownArea';
        Tyrerejection.ETT_Inspection_Card__c = inspectionList[0].id;
        insert Tyrerejection;
        
        
    try{
        ETT_JobCardCloseCtrlNew.createJCcloseLinesUnderJC(Jobcardcloseline, jc.Id, JcemployeeList, JcRejection, jb);
    }catch(Exception e){}
    }*/

}