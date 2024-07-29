@isTest
public class ETT_TyreInspectionCardController_Test {
    
    public static testMethod void myUnitTest() {
        
        Account objAcc = new Account();
        objAcc.Name = 'TestAccount';
        insert objAcc;
        
        ETT_Price_Master__c objPM = new ETT_Price_Master__c();
        objPM.ETT_Party_Name__c = objAcc.Id;
        insert objPM;
        
        ETT_Collection_Card__c objCC = new ETT_Collection_Card__c();
        objCC.ETT_Accounts__c = objAcc.Id;
        //objCC.ETT_Status__c = 'New';
        //objCC.RecordTypeId = Schema.SObjectType.ETT_Collection_Card__c.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        insert objCC;
        
        
        ETT_Inspection_Card__c objIC = new ETT_Inspection_Card__c();
        //objIC.RecordTypeId = Schema.SObjectType.ETT_Inspection_Card__c.getRecordTypeInfosByName().get('Tyre - Cash Supplier').getRecordTypeId();
        objIC.ETT_Collection_Card__c = objCC.Id;
        objIC.ETT_Status__c = 'Accept';
        insert objIC;
        
        
        
        
        
        
        ETT_TyreInspectionCardController.getInspectionCardTyreLife(objIC.Id);
        ETT_TyreInspectionCardController.getselectOptions();
        ETT_TyreInspectionCardController.getInspectionCardDetails(objIC.Id);
        
        ETT_Country_Master__c objCountry = ETT_TestFactory.createCountries('Japan');
        List<ETT_Pattern_Master__c> lstPatternMaster = ETT_TestFactory.createPatternMasters();
        List<ETT_Tyre_Size_Master__c> lstTyreSizeMaster = ETT_TestFactory.createTyreSizeMaster();
        List<ETT_Brand_Master__c> lstBrandMaster = ETT_TestFactory.createBrandMasters();
        
        List<ETT_Tyre_Master__c> lstTyreMaster = ETT_TestFactory.createTyreMasters('Draft', lstPatternMaster[0].Id, objCountry.Id , lstTyreSizeMaster[0].Id, lstBrandMaster[0].Id);
        
        if(lstTyreMaster!=null && lstTyreMaster.size()>0){
            for(ETT_Tyre_Master__c ic:lstTyreMaster){
                ic.ETT_Tyre_Inspection_Card__c = objIC.Id;
            }
            insert lstTyreMaster;
        }
        
        ETT_TyreInspectionCardController.getNewTyreDetailsfromIC(objIC.Id);
        
        List<ETT_TyreInspectionCardWrapper.TyreRejectionLineItem> objTyreRejectionLineItem = new List<ETT_TyreInspectionCardWrapper.TyreRejectionLineItem>();
        List<ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem> lstTyreRejectionSubLineItem = new List<ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem>();
        
        
        List<ETT_TyreInspectionCardWrapper.FileWrapper> lstFileWrapper = new List<ETT_TyreInspectionCardWrapper.FileWrapper>();
        ETT_TyreInspectionCardWrapper.FileWrapper objFileWrapper = new ETT_TyreInspectionCardWrapper.FileWrapper();
        Blob beforeblob = Blob.valueOf('before');
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        objFileWrapper.fileContent = paramvalue;
        objFileWrapper.fileSourceType = 2;
        objFileWrapper.parentId = '002';
        objFileWrapper.strFileName = 'testImg.png';
        objFileWrapper.strFileType = 'image/png';
        objFileWrapper.strRejectionName = 'CrownArea';
        lstFileWrapper.add(objFileWrapper);
        
        
        
        ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem objTyreRejectionSubLineItem = new ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem();
        objTyreRejectionSubLineItem.strRejectionName = 'Shoulder Step or Chamfer Wear';
        objTyreRejectionSubLineItem.strCauseOfRejection = 'Test Cause';
        objTyreRejectionSubLineItem.strRecommendations = 'Test';
        objTyreRejectionSubLineItem.strOtherComments = 'Test Comment';
        objTyreRejectionSubLineItem.strStatus = 'Rejected';
        objTyreRejectionSubLineItem.strParentRejectionName = 'CrownArea';
        objTyreRejectionSubLineItem.lstFileWrapperDetails = lstFileWrapper;
        
        lstTyreRejectionSubLineItem.add(objTyreRejectionSubLineItem);
        
        
        List<ETT_TyreInspectionCardWrapper.FileWrapperNTC> lstFileWrapperNTC = new List<ETT_TyreInspectionCardWrapper.FileWrapperNTC>();
        ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapperNTC = new ETT_TyreInspectionCardWrapper.FileWrapperNTC();
        objFileWrapperNTC.fileContent = 'Test Txt';
        objFileWrapperNTC.fileSourceType = 'CrownArea';
        objFileWrapperNTC.parentId = '123';
        objFileWrapperNTC.strFileName = 'imgTest.png';
        objFileWrapperNTC.strFileType = 'image/png';
        objFileWrapperNTC.strRejectionName = 'Shoulder Step or Chamfer Wear';
        lstFileWrapperNTC.add(objFileWrapperNTC);
        
        
        List<ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper> lstFileWrapperNTCCutsWrapper = new List<ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper>(); 
        ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper obj = new ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper();            
        obj.file = lstFileWrapperNTC;
        obj.label = 'Cuts (0 to 10mm)';
        obj.selectedValue = '2.5';
        lstFileWrapperNTCCutsWrapper.add(obj);
        
        
        
        
        ETT_TyreInspectionCardWrapper.TyreRejectionLineItem objTRLI = new ETT_TyreInspectionCardWrapper.TyreRejectionLineItem();
        objTRLI.tyreRejectionName = 'CrownArea';
        objTRLI.goodCondition = 'No';
        objTRLI.strRecordTypeName = 'New Tyre and Casing Inspection Procedures';
        objTRLI.lstTyreRejectionSubLineItems = lstTyreRejectionSubLineItem;
        objTRLI.cuts_0_to_10 = lstFileWrapperNTCCutsWrapper;
        objTRLI.cuts_11_to_25 = lstFileWrapperNTCCutsWrapper;
        objTRLI.cuts_26_to_38 = lstFileWrapperNTCCutsWrapper;
        objTRLI.cuts_39_to_50 = lstFileWrapperNTCCutsWrapper;
        objTRLI.cuts_51 = lstFileWrapperNTCCutsWrapper;
        objTyreRejectionLineItem.add(objTRLI);
        
        
        ETT_TyreInspectionCardWrapper.InspectionTechincalSkill objInspectionSkill = new ETT_TyreInspectionCardWrapper.InspectionTechincalSkill();
        objInspectionSkill.isWearRequiredPPT= true;
        objInspectionSkill.isSuportingToolsavilable = true;
        objInspectionSkill.isEletornicProbinWorkingCondition= true;
        objInspectionSkill.isTyreSprederisWorkingCondtion= true;
        objInspectionSkill.isSpreadLightCondtion= true;
        objInspectionSkill.isTyreLiftinWorkingCondition= true;
        objInspectionSkill.revision = '200';
        objInspectionSkill.lstTyreRejectionLineItems = objTyreRejectionLineItem;   
        
        String strInspectionSkillJson = JSON.serialize(objInspectionSkill);
        String strInspectionJson = JSON.serialize(objIC);        
        
        
        //ETT_TyreInspectionCardController.tyreInsectionCardProcess(strInspectionJson, strInspectionSkillJson, 'Supplier');
        
        Test.startTest();
        //ETT_TyreInspectionCardController.tyreInsectionJobCardProcess(strInspectionJson, strInspectionSkillJson, 'Supplier');
        ETT_TyreInspectionCardController.getRelatedWOLI(objIC.Id);

        /*List<ETT_Tyre_Size_Master__c> lstTyreSizeMaster = ETT_TestFactory.createTyreSizeMaster();        
        List<ETT_Brand_Master__c> lstBrandMaster = ETT_TestFactory.createBrandMasters();
        ETT_Country_Master__c objCountry = ETT_TestFactory.createCountries('Japan');
        List<ETT_Pattern_Master__c> lstPatternMaster = ETT_TestFactory.createPatternMasters();
*/
        
        //ETT_TestFactory.createTyreMasters(recTypeName, patternMasterId, countryId, tyreSizeMasterId, brandMasterId);
        
        map<string,string> mapofStageJsonList = new map<string,string> ();
        mapofStageJsonList.put('lstTyreMasterJson', JSON.serialize(lstTyreMaster));
        ETT_TyreInspectionCardController.approveNewTyres(mapofStageJsonList);
        
        
        ETT_Job_Card__c objJC = new ETT_Job_Card__c();
        objJC.ETT_Stages__c = 'Cementing';
        insert objJC;
        
        ETT_Tyre_Rejection_Line_Item__c objRLI = new ETT_Tyre_Rejection_Line_Item__c();
        objRLI.ETT_Job_Card__c = objJC.Id;
        insert objRLI;
        
        ETT_TyreInspectionCardController.getInspectionCardDetails(objRLI.Id);
        ETT_TyreInspectionCardController.getjobCardDetails(objRLI.Id);
        ETT_TyreInspectionCardController.createStagingQuotation(objIC.Id, 200);
        
        List<WorkOrderLineItem> lstWorkOrderLineItem = new List<WorkOrderLineItem>();
        
        WorkOrderLineItem objWOLI = new WorkOrderLineItem(); 
        objWOLI.ETT_Brand__c = lstBrandMaster[0].Id;
        objWOLI.ETT_Tyre_Size__c = lstTyreSizeMaster[0].Id;
        objWOLI.ETT_Country_of_Origin__c = objCountry.Id;
        objWOLI.ETT_Pattern__c = lstPatternMaster[0].Id;
        objWOLI.Status = 'New';
        objWOLI.ETT_Accepted_By_Receptionist__c=true;
        lstWorkOrderLineItem.add(objWOLI);
        
       // ETT_TyreInspectionCardController.updateRelatedWOLI(lstWorkOrderLineItem);

        List<ETT_Staging_Quotation_Request__c> lstStgQuotation = new List<ETT_Staging_Quotation_Request__c>();
        ETT_Staging_Quotation_Request__c objstgQuotReq = new ETT_Staging_Quotation_Request__c();
        objstgQuotReq.ETT_Brand__c = lstBrandMaster[0].Id;
        objstgQuotReq.ETT_Tyre_Size_Master__c = lstTyreSizeMaster[0].Id;
        objstgQuotReq.ETT_Country__c = objCountry.Id;
        objstgQuotReq.ETT_Pattern__c = lstPatternMaster[0].Id;
        objstgQuotReq.ETT_Inspection_Card__c = objIC.Id;
        objstgQuotReq.ETT_Collection_Card__c = objCC.Id;
        objstgQuotReq.ETT_Min_Range__c = 100;
        objstgQuotReq.ETT_Max_Range__c = 700;
        objstgQuotReq.ETT_Purchase_Price__c = 600;
        insert objstgQuotReq;
        lstStgQuotation.add(objstgQuotReq);
        
        ETT_Price_Master__c pm2 = new ETT_Price_Master__c();
        pm2.ETT_Party_Name__c = objAcc.Id;
        insert pm2;
        
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();
        epi.ETT_Price__c=pm2.Id;
        epi.ETT_Approval_Status__c ='Approved';
        insert epi;
        
        ETT_Tyre_Size_Master__c tsm = new ETT_Tyre_Size_Master__c();
        tsm.Name ='Size1967';
        insert tsm;
        
        ETT_Pattern_Master__c pat = new ETT_Pattern_Master__c();
        pat.Name ='Pat21';
        insert pat;
        
        ETT_Country_Master__c coun = new ETT_Country_Master__c();
        coun.Name ='Coun1';
        insert coun;
        
        ETT_Brand_Master__c bra = new ETT_Brand_Master__c();
        bra.Name ='Bran1';
        insert bra;
        
        ETT_Tyre_Inventory__c tin3 = new ETT_Tyre_Inventory__c();
        tin3.ETT_Account__c = objAcc.Id;
        tin3.ETT_Collection_Card__c = objCC.id;
        tin3.Serial_Number__c = '243254454';
        tin3.ETT_Inventory_Status__c='Draft';
        tin3.ETT_Brand__c = bra.Id;
        tin3.ETT_Country__c=coun.id;
        tin3.ETT_Pattern__c=pat.id;
        tin3.ETT_Tyre_Size_Master__c=tsm.Id;
        tin3.ETT_Tyre_Master__c = lstTyreMaster[0].Id;
        tin3.ETT_Tyre_Inspection_Card__c = objIC.Id;
        tin3.ETT_Work_Order_Line_Item__c = objWOLI.id;
        insert tin3;
        
        
        ETT_TyreInspectionCardController.getStagingQuotation(objstgQuotReq.Id);
        ETT_TyreInspectionCardController.FMPriceApproval(objIC.Id, lstStgQuotation);
        
        ETT_TyreInspectionCardController.tyreInsectionCardProcess(strInspectionJson, strInspectionSkillJson, 'Supplier');
        ETT_TyreInspectionCardController.tyreInsectionJobCardProcess(strInspectionJson, strInspectionSkillJson, 'Supplier');
        
        Test.stopTest();        
        
        
        
    }
    
}