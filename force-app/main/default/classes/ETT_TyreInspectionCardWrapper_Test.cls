@isTest
public class ETT_TyreInspectionCardWrapper_Test {
    
    static TestMethod void tyreInspectionCardWrapper_TestClass(){
        
        ETT_TyreInspectionCardWrapper obj = new ETT_TyreInspectionCardWrapper();
        
        ETT_TyreInspectionCardWrapper.InspectionTechincalSkill objInspectionTechincalSkill = new ETT_TyreInspectionCardWrapper.InspectionTechincalSkill();
        objInspectionTechincalSkill.isEletornicProbinWorkingCondition = true;
        objInspectionTechincalSkill.isSpreadLightCondtion = true;
        objInspectionTechincalSkill.isSuportingToolsavilable = true;
        objInspectionTechincalSkill.isTyreLiftinWorkingCondition = true;
        objInspectionTechincalSkill.isTyreSprederisWorkingCondtion = true;
        objInspectionTechincalSkill.isWearRequiredPPT = true;
        objInspectionTechincalSkill.revision = '1';
        objInspectionTechincalSkill.jobCardStage = 'Repair';
        
        List<ETT_TyreInspectionCardWrapper.FileWrapper> lstFileWrapper = new List<ETT_TyreInspectionCardWrapper.FileWrapper>();
        ETT_TyreInspectionCardWrapper.FileWrapper objFileWrapper = new ETT_TyreInspectionCardWrapper.FileWrapper();
        objFileWrapper.strFileName = 'testImg.png';
        objFileWrapper.strFileType = 'image/png';
        objFileWrapper.fileSourceType = 1;
        objFileWrapper.fileContent = '';
        objFileWrapper.parentId = '';
        objFileWrapper.strRejectionName = 'BeadArea';
        lstFileWrapper.add(objFileWrapper);
        
        
        List<ETT_TyreInspectionCardWrapper.FileWrapperNTC> lstFileWrapperNTC = new List<ETT_TyreInspectionCardWrapper.FileWrapperNTC>();
        ETT_TyreInspectionCardWrapper.FileWrapperNTC objFileWrapperNTC = new ETT_TyreInspectionCardWrapper.FileWrapperNTC();
        objFileWrapperNTC.strFileName = 'testImg.png';
        objFileWrapperNTC.strFileType = 'image/png';
        objFileWrapperNTC.fileSourceType = '1';
        objFileWrapperNTC.fileContent = '';
        objFileWrapperNTC.parentId = '';
        objFileWrapperNTC.strRejectionName = 'BeadArea';        
        lstFileWrapperNTC.add(objFileWrapperNTC);

        ETT_TyreInspectionCardWrapper.FileWrapperNTCCuts objFileWrapperNTCCuts = new ETT_TyreInspectionCardWrapper.FileWrapperNTCCuts();
        objFileWrapperNTCCuts.label = 'testImage';
        objFileWrapperNTCCuts.strFileName = 'testImg.png';
        objFileWrapperNTCCuts.strFileType = 'image/png';
        objFileWrapperNTCCuts.fileSourceType = 1;
        objFileWrapperNTCCuts.fileContent = '';
        objFileWrapperNTCCuts.parentId = '';
        objFileWrapperNTCCuts.strRejectionName = 'BeadArea';        
        
        List<ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper> lstFileWrapperNTCCutsWrapper = new List<ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper>(); 
        ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper objFileWrapperNTCCutsWrapper = new ETT_TyreInspectionCardWrapper.FileWrapperNTCCutsWrapper();
        objFileWrapperNTCCutsWrapper.label = 'testImage';
        objFileWrapperNTCCutsWrapper.selectedValue = '1';
        objFileWrapperNTCCutsWrapper.file = lstFileWrapperNTC;
        lstFileWrapperNTCCutsWrapper.add(objFileWrapperNTCCutsWrapper);    
            
        ETT_TyreInspectionCardWrapper.TyreRejectionLineItem objTyreRejectionLineItem = new ETT_TyreInspectionCardWrapper.TyreRejectionLineItem();
        objTyreRejectionLineItem.tyreRejectionName = 'BeadArea';
        objTyreRejectionLineItem.goodCondition = 'Yes';
        objTyreRejectionLineItem.strRecordTypeName = 'ETT_Supplier';
        objTyreRejectionLineItem.cuts_0_to_10 = lstFileWrapperNTCCutsWrapper;
        objTyreRejectionLineItem.cuts_11_to_25 = lstFileWrapperNTCCutsWrapper;
        objTyreRejectionLineItem.cuts_26_to_38 = lstFileWrapperNTCCutsWrapper;
        objTyreRejectionLineItem.cuts_39_to_50 = lstFileWrapperNTCCutsWrapper;
        objTyreRejectionLineItem.cuts_51 = lstFileWrapperNTCCutsWrapper;
        
        
        ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem objTyreRejectionSubLineItem = new ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItem();
        objTyreRejectionSubLineItem.strRejectionName = 'BeadArea';
        objTyreRejectionSubLineItem.strCauseOfRejection = 'test';
        objTyreRejectionSubLineItem.strRecommendations = 'test msg';
        objTyreRejectionSubLineItem.strOtherComments = 'test comment';
        objTyreRejectionSubLineItem.strStatus = 'good';
        objTyreRejectionSubLineItem.lstFileWrapperDetails = lstFileWrapper;
        //objTyreRejectionSubLineItem.recordId = '';        


/*
 @Auraenabled public string strRejectionName{get; set;}
        @Auraenabled public string strCauseOfRejection{get; set;}
        @Auraenabled public string strRecommendations{get; set;}
        @Auraenabled public string strOtherComments{get; set;}
        @Auraenabled public string strStatus{get; set;}
        @Auraenabled public string strParentRejectionName{get; set;}
        @Auraenabled public list<FileWrapper> lstFileWrapperDetails{get; set;}
        @Auraenabled public Id recordId{get; set;}//Kumaresan added
    }
*/
        
        ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItems objTyreRejectionSubLineItems = new ETT_TyreInspectionCardWrapper.TyreRejectionSubLineItems();
        objTyreRejectionSubLineItems.Account = 'TestAcc';
        objTyreRejectionSubLineItems.Brand = 'SmallTyre';
        objTyreRejectionSubLineItems.CCName = 'CCName';
        objTyreRejectionSubLineItems.Country = 'Japan';
        objTyreRejectionSubLineItems.Driver = 'Anil';
        objTyreRejectionSubLineItems.Pattern = 'PRT';
        objTyreRejectionSubLineItems.Quantity = '2';
        objTyreRejectionSubLineItems.RecordKey = 'testKey';
        objTyreRejectionSubLineItems.TyreSize = '12R.24.00.2';
        objTyreRejectionSubLineItems.ServiceAppointment = '001';
        objTyreRejectionSubLineItems.RejectionReason = 'Test';
        objTyreRejectionSubLineItems.lstFileWrapperDetails = lstFileWrapper;
        
        /*
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
*/
        
    }
    
}