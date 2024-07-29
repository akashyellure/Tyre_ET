/*
  CreatedDate:08-28-2020
  CreatedBy:G.Krishnareddy
  Description:This is for Inspection Creteria procedures to show the differenciations on each part.
*/
public class ETT_TyreInspectionCardWrapper { 
    
    public ETT_TyreInspectionCardWrapper(){
        
    }
    
    public class InspectionTechincalSkill{
        public InspectionTechincalSkill(){}
        @Auraenabled public boolean isWearRequiredPPT{get; set;}
        @Auraenabled public boolean isSuportingToolsavilable{get; set;}
        @Auraenabled public boolean isEletornicProbinWorkingCondition{get; set;}
        @Auraenabled public boolean isTyreSprederisWorkingCondtion{get; set;}
        @Auraenabled public boolean isSpreadLightCondtion{get; set;}
        @Auraenabled public boolean isTyreLiftinWorkingCondition{get; set;}
        @Auraenabled public list<TyreRejectionLineItem> lstTyreRejectionLineItems{get; set;}
        @Auraenabled public ID JobCardId{get;set;}
        @Auraenabled public String revision{get;set;}
        @Auraenabled public String jobCardStage{get;set;}
    }
    
    public class TyreRejectionLineItem{
        @Auraenabled public string tyreRejectionName {get; set;}
        @Auraenabled public string goodCondition{get; set;}
        @Auraenabled public string strRecordTypeName{get; set;}
        @Auraenabled public Boolean strBeadwireloosening{get; set;}
        @Auraenabled public Boolean strBeadBundleCrack{get; set;}
        @Auraenabled public Boolean strBeadTurnupChafourLoose{get; set;}
        @Auraenabled public Boolean strBeadHardBead{get; set;}
        @Auraenabled public Boolean strTyreInteriorSpot{get; set;}
        @Auraenabled public Boolean strTyreInteriorExtended {get; set;}
        @Auraenabled public Boolean strTyreInteriorNotRepairable{get; set;}
        @Auraenabled public string strCuts{get; set;}
        @Auraenabled public string strNailPun{get; set;}
        //@Auraenabled public list<FileWrapperNTCCutsWrapper> cut_size{get; set;}
        @Auraenabled public list<FileWrapperNTCCutsWrapper> cuts_0_to_10{get; set;}        
        @Auraenabled public list<FileWrapperNTCCutsWrapper> cuts_11_to_25{get; set;}
        @Auraenabled public list<FileWrapperNTCCutsWrapper> cuts_26_to_38{get; set;}
        @Auraenabled public list<FileWrapperNTCCutsWrapper> cuts_39_to_50{get; set;}
        @Auraenabled public list<FileWrapperNTCCutsWrapper> cuts_51{get; set;}
        @Auraenabled public list<TyreRejectionSubLineItem> lstTyreRejectionSubLineItems{get; set;}
        @Auraenabled public Id recordId{get; set;}//Kumaresan added
        @Auraenabled public Boolean Buttress_Crack_Shoulder_Crack{get; set;}//Janardhan added
        @Auraenabled public Boolean Strain_Mark{get; set;}//Janardhan added
        @Auraenabled public Boolean Uneven_Wear{get; set;}//Janardhan added
        @Auraenabled public Decimal Groove_Channel_Crack{get; set;}//Janardhan added
        @Auraenabled public Decimal Thread_wornout{get; set;}//Janardhan added
        @Auraenabled public Decimal Excessive_One_sided_Wear{get; set;}//Janardhan added
        @Auraenabled public Decimal Steer_Axle_Rpd_Shoulder_Wear_1_Shoulder{get; set;}//Janardhan added
        @Auraenabled public Decimal Steer_Axle_Rpd_Shuldr_Wear_Both_Shoulder{get; set;}//Janardhan added
        @Auraenabled public Decimal Drive_Axle_Rpd_Shoulder_Wear_1_Shoulder{get; set;}//Janardhan added
        @Auraenabled public Decimal Drive_Axle_Rpd_Shuldr_Wear_Both_Shoulder{get; set;}//Janardhan added
        @Auraenabled public Decimal Trailer_Axle_Rpd_Shulder_Wear_1_Shoulder{get; set;}//Janardhan added
        @Auraenabled public Decimal Trailer_Axle_Rpd_Shuldr_Wear_Both_Shlder{get; set;}//Janardhan added
        
        @Auraenabled public String Approval_Status{get; set;}//Janardhan added
    }
    
    public class TyreRejectionSubLineItem{
        @Auraenabled public string strRejectionName{get; set;}
        @Auraenabled public string strCauseOfRejection{get; set;}
        @Auraenabled public string strRecommendations{get; set;}
        @Auraenabled public string strOtherComments{get; set;}
        @Auraenabled public string OtherCommentByTech{get; set;}  
        @Auraenabled public string strPercentage{get;set;}
        @Auraenabled public string strNOC{get;set;}
        @Auraenabled public string strNOS{get;set;}
        @Auraenabled public string strSOS1{get;set;}
        @Auraenabled public string strSOS2{get;set;}
        @Auraenabled public string strSOS3{get;set;}
        @Auraenabled public string strSOS4{get;set;}
        @Auraenabled public string strSOS5{get;set;}
        @Auraenabled public string strSOS6{get;set;}
        @Auraenabled public string strSOS7{get;set;}
        @Auraenabled public string strSOS8{get;set;}
        @Auraenabled public string strSOS9{get;set;}
        @Auraenabled public string strSOS10{get;set;}
        @Auraenabled public string strStatus{get; set;}
        @Auraenabled public string strParentRejectionName{get; set;}
        @Auraenabled public list<FileWrapper> lstFileWrapperDetails{get; set;}
        @Auraenabled public Id recordId{get; set;}//Kumaresan added
    }
    
    public class TyreRejectionSubLineItems{
        @Auraenabled public string TyreSize{get; set;}
        @Auraenabled public string Brand{get; set;}
        @Auraenabled public string Pattern{get; set;}
        @Auraenabled public string Country{get; set;}
        @Auraenabled public string Quantity{get; set;}
        @Auraenabled public string RecordKey{get; set;}
        @Auraenabled public string CCName{get; set;}
        @Auraenabled public string CCId{get; set;}
        @Auraenabled public string Account{get; set;}
        @Auraenabled public string Driver{get; set;}
        @Auraenabled public string ServiceAppointment{get; set;}
        @Auraenabled public string RejectionReason{get; set;}
        @Auraenabled public ETT_Tyre_Rejection_Report__c objTyreRejectionSubLineItems{get; set;}
        @Auraenabled public list<FileWrapper> lstFileWrapperDetails{get; set;}
    }
    
    public class FileWrapper{
        @Auraenabled public string strFileType{get; set;}
        @Auraenabled public string strFileName{get; set;}
        @Auraenabled public string fileContent{get; set;}
        @Auraenabled public Integer fileSourceType{get; set;}        
        @Auraenabled public string strRejectionName{get; set;}
        @Auraenabled public string parentId{get; set;}
    }

    public class FileWrapperNTC{
        @Auraenabled public string strFileType{get; set;}
        @Auraenabled public string strFileName{get; set;}
        @Auraenabled public string fileContent{get; set;}
        @Auraenabled public string fileSourceType{get; set;}        
        @Auraenabled public string strRejectionName{get; set;}
        @Auraenabled public string parentId{get; set;}
    }
    
    public class FileWrapperNTCCutsWrapper{
        @Auraenabled public string label{get; set;}
        @Auraenabled public string selectedValue{get; set;}
        @Auraenabled public list<FileWrapperNTC> file{get; set;}
    }
    
    public class FileWrapperNTCCuts{
        @Auraenabled public string label{get; set;}
        @Auraenabled public string strFileType{get; set;}
        @Auraenabled public string strFileName{get; set;}
        @Auraenabled public string fileContent{get; set;}
        @Auraenabled public Integer fileSourceType{get; set;}        
        @Auraenabled public string strRejectionName{get; set;}
        @Auraenabled public string parentId{get; set;}
    }    
}