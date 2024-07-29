/*Create By: Shweta Shinde
* Date: 30th May 2020
* Description: Community Site Registration Class
*/
public without sharing class ETT_CommunitiesSiteRegFormController {
    
    
    @AuraEnabled 
    public static String registerCommunityPortalUser(map<string,string> mapofStageJsonList, String password){
        
        User objUser;
        Account objAcc;
        Contact objContact = new Contact();
        //ETT_Bank_Reference__c objBank;
        list<ETT_FileUploadWrapper> lstFileUploadWrapper;
        String userId;
        
        //User u = [SELECT Id,Name FROM User where Email='krishna.reddy@smaartt.com' limit 1];        
        User u = [SELECT Id, Name, Username, Email, Profile.Name, UserRole.Name FROM User where Profile.Name='System Administrator' and IsActive = true and UserRole.Name != null limit 1];
        
        System.debug(u);
        
        if(mapofStageJsonList.containskey('objAccountJson')){
            objAcc = (Account) JSON.deserialize(mapofStageJsonList.get('objAccountJson'),Type.forname('Account'));
            System.debug(objAcc);
        }        
        
        /*if(mapofStageJsonList.containskey('objBank')){
objBank = (ETT_Bank_Reference__c) JSON.deserialize(mapofStageJsonList.get('objBank'),Type.forname('ETT_Bank_Reference__c'));
System.debug(objBank);
} */     
        
        if(mapofStageJsonList.containskey('filesToUpload')){
            lstFileUploadWrapper =  (list<ETT_FileUploadWrapper>)JSON.deserialize(mapofStageJsonList.get('filesToUpload'),Type.forname('list<ETT_FileUploadWrapper>'));
        }
        
        if(mapofStageJsonList.containskey('objUserJson')){
            objUser = (User) JSON.deserialize(mapofStageJsonList.get('objUserJson'),Type.forname('User'));
            System.debug(objUser);
        }
        
        
        if(objAcc != null){
            try{
                System.debug('inside try of Account');
                objAcc.OwnerId = u.Id;
                if(objUser.ETT_Customer_Type__c == 'Person'){
                    objAcc.Party_Type__c = 'Customer';
                    objAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Tyre Customer').getRecordTypeId();
                }else{
                    objAcc.Party_Type__c = 'Supplier';
                    objAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId();
                }
                
                /*objAcc.ETT_Bank_Account_Name__c = objBank.ETT_Account_Name__c;
objAcc.ETT_Bank_Account_Number__c = objBank.ETT_Account_Number__c;
objAcc.ETT_Bank_Branch_Name__c = objBank.ETT_Branch_Name__c;
objAcc.ETT_IBAN_Txt__c = objBank.ETT_IBAN__c;
objAcc.ETT_Bank_Name__c = objBank.ETT_Bank_Name__c;*/
                objAcc.ETIN_Mobile_Number__c = objUser.Phone;
                
                System.debug('objAcc: '+objAcc);
                insert objAcc;
                
                
                /*try{
objBank.ETT_Account__c = objAcc.Id;
insert objBank;
}Catch(Exception ex){
system.debug('***Exception Cause Bank*****'+ex.getMessage());
}*/
            }Catch(Exception ex){
                system.debug('***Exception Cause Account*****'+ex.getMessage());
            }
        }
        
        
        if(lstFileUploadWrapper!=null && lstFileUploadWrapper.size()>0){
            list<ContentVersion> lstContentVesions = new list<ContentVersion>();
            list<ContentDocumentLink> lstContentDocumentLinks = new list<ContentDocumentLink>();
            list<Attachment> lstAttachments = new list<Attachment>();           
            for(ETT_FileUploadWrapper objFileUploadWrapper :lstFileUploadWrapper){
                Attachment objAttachment=new Attachment();   	
                objAttachment.Name=objFileUploadWrapper.strFileName;
                Blob bodyBlob=EncodingUtil.base64Decode(objFileUploadWrapper.strBase64Data);
                objAttachment.body=bodyBlob;
                objAttachment.parentId= objAcc.id; 
                lstAttachments.add(objAttachment);
            }
            
            try{ 
                insert lstAttachments;  
                system.debug('***lstAttachments*****'+lstAttachments);
            }Catch(Exception ex){
                system.debug('****Exception Cause ****'+ex.getMessage());
            }
            /* for(ETT_FileUploadWrapper objFileUploadWrapper :lstFileUploadWrapper){
ContentVersion objContentVersion = new ContentVersion();
objContentVersion.ContentLocation = 'S';
objContentVersion.VersionData = EncodingUtil.base64Decode(objFileUploadWrapper.strBase64Data);
objContentVersion.Title = objFileUploadWrapper.strFileName;
objContentVersion.PathOnClient = objFileUploadWrapper.strFileType;
lstContentVesions.add(objContentVersion);
}
system.debug('******lstContentVesions****'+lstContentVesions);
if(lstContentVesions!=null && lstContentVesions.size()>0){

try{
insert lstContentVesions;   
system.debug('******After lstContentVesions****'+lstContentVesions);
}Catch(Exception ex){
system.debug('***Exception Cause lstContentVesions*****'+ex.getMessage());
system.debug('***Exception Cause getStackTraceString*****'+ex.getStackTraceString());
throw new AuraHandledException('Error Exception happend'+ex.getStackTraceString());                                       
}

map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
for(ContentVersion objContentVersion :[Select Id,ContentDocumentId from ContentVersion where Id in :lstContentVesions]){
mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
}

for(ContentVersion objContentVersion :lstContentVesions){

if(mapofContentVersionIdwithContentDocumentIds.containskey(objContentVersion.Id)){
ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
objContentDocumentLink.LinkedEntityId = objAcc.Id;
objContentDocumentLink.ShareType = 'V';
objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id);
lstContentDocumentLinks.add(objContentDocumentLink);
}

}
system.debug('******lstContentDocumentLinks****'+lstContentDocumentLinks);
if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
try{
insert lstContentDocumentLinks;                    
}Catch(Exception ex){
system.debug('***Exception Cause lstContentDocumentLinks*****'+ex.getMessage());
system.debug('***Exception lstContentDocumentLinks getStackTraceString*****'+ex.getStackTraceString());
throw new AuraHandledException('Error Exception lstContentDocumentLinks'+ex.getStackTraceString());                                       
}
}
}*/
        }
        
        
        if(objAcc != null && objUser != null){
            
            ID contactRecordTypeId;
            if(objUser.ETT_Customer_Type__c == 'Person'){
                contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Tyre Customer').getRecordTypeId();
            }else{
                contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Tyre Supplier').getRecordTypeId();
            }
            System.debug('User: '+objUser);
            System.debug('objAcc: '+objAcc);
            
                objContact.FirstName = objUser.FirstName;
                objContact.LastName = objUser.LastName;
                objContact.AccountId = objAcc.Id;
                objContact.Email = objUser.Email;
                objContact.MobilePhone = objUser.Phone;
                objContact.RecordTypeId = contactRecordTypeId;
            
            
            System.debug('objContact: '+objContact);
                
            try{
                insert objContact;
                
                /*Opportunity opp = new Opportunity();
opp.Name = objAcc.Name;
opp.StageName = 'New';
opp.AccountId = objAcc.Id;
opp.ContractId = objContact.Id;
insert opp;*/
                
                List<Profile> p = new List<Profile>();
                
                if(objUser.ETT_Customer_Type__c == 'Organization'){
                    p = [SELECT Id FROM Profile WHERE Name='ETT_Tyre Partner Community Portal'];                     
                }else if(objUser.ETT_Customer_Type__c == 'Person'){
                    p = [SELECT Id FROM Profile WHERE Name='ETT_Tyre Customer Community Portal'];                     
                }
                
                System.debug('P: '+p);
                
                objUser.ProfileId = p[0].Id;
                objUser.TimeZoneSidKey ='Asia/Dubai';
                objUser.LanguageLocaleKey ='en_US';
                objUser.EmailEncodingKey ='UTF-8';
                objUser.LocaleSidKey = 'en_US';
                objUser.ContactId = objContact.Id;
                objUser.CommunityNickName = string.valueOf(math.random()).substring(0,6);
                //DateTime currentTime = System.now(); 
                //Long timeInMili = currentTime.getTime()/1000; 
                //objUser.CommunityNickname = objUser.Username;
                
                try{
                    try {  
                        userId = Site.createExternalUser(objUser, objAcc.Id, password);
                        System.debug('after user'+userId);
                    } catch(Site.ExternalUserCreateException ex) {
                        
                        List<String> errors = ex.getDisplayMessages();
                        for (String error : errors)  {
                            System.debug(error);
                        }
                        System.debug(ex.getMessage());
                        //System.debug('site external'+ex.getMessage());
                        //System.debug(ex.getDisplayMessages());
                        //throw new AuraHandledException('site external'+ex.getMessage());                   
                    }
                    
                    
                    
                }Catch(Exception ex){
                    system.debug('***Exception Cause objUser*****'+ex.getMessage());
                    //throw new AuraHandledException('objUser'+ex.getMessage());                                       
                }
                
            }Catch(Exception ex){
                system.debug('***Exception Cause contact*****'+ex.getMessage());
                //throw new AuraHandledException('Error Exception contact'+ex.getMessage());                                   
            }
        }
        
        
        return null;
        
    }
    
    
}