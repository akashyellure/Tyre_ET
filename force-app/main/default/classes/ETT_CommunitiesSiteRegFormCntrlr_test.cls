@isTest
public class ETT_CommunitiesSiteRegFormCntrlr_test {
    @isTest(SeeAllData=true)
    static  void CommunitiesSiteRegFormCntrlr_test(){
        
        map<string,string> mapofStageJsonList = new map<string,string> ();
        map<string,string> Stringpassword = new map<string,string> ();
        
        Profile p = new Profile();
        p.Name = 'ETT_Tyre Customer Community Portal';
        //insert p;
        
        User objUser = new User();
        objUser.Phone = '+971 422343454';
        objUser.FirstName = 'Rohan';
        objUser.LastName = 'Singh';
        objUser.Email = 'rohans@gm.com';
        objUser.ETT_Customer_Type__c = 'Person';
        Account objAcc = new Account(Name = 'Company Internal');
        
        
        ETT_FileUploadWrapper wrp = new ETT_FileUploadWrapper();
        wrp.fileSourceType = 'Test';
        wrp.strFileType = 'Test';
        wrp.strBase64Data = 'Test';
        wrp.strFileName = 'Test';
        list<ETT_FileUploadWrapper> lstWrapper = new list<ETT_FileUploadWrapper>{wrp};
            
        mapofStageJsonList.put('objUserJson', JSON.serialize(objUser));
        mapofStageJsonList.put('objAccountJson', JSON.serialize(objAcc));
        mapofStageJsonList.put('filesToUpload', JSON.serialize(lstWrapper));
        
        
        Test.startTest();
        ETT_CommunitiesSiteRegFormController.registerCommunityPortalUser(mapofStageJsonList, 'Test');
        Test.stopTest();
        
        
        
    }
}