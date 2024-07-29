/**
* Author:Janardhan
* Desc:
* Created Date:21/11/2021
* Test Class: ETT_PriceConfirmationCtrlTest
* */
public class ETT_PriceConfirmationCtrl {
    
    @auraEnabled
    public static list<ETT_Staging_Quotation_Request__c> getAllStagQuotReq(string recordId){
        
        list<ETT_Staging_Quotation_Request__c> lstStagQuotaionReq = [Select Id,ETT_Min_Range__c,Approver_Status__c,ETT_Max_Range__c,ETT_Purchase_Price__c,ETT_Brand__r.Name,ETT_Pattern__r.Name,ETT_Country__r.Name,ETT_Tyre_Size_Master__r.Name,ETT_Approve_Stage__c,ETT_IS_Approved__c,ETT_Quantity__c,ETT_Rejection_Comments__c,ETT_Retreading_charge__c,ETT_Stock_Retreading_Charge__c,ETT_Tyre_Size_Master__c,ETT_Tyre_Life__c,ETT_Tyre_Condition__c,ETT_Tyre_Process__c,ETT_Reasons_For_Price_Reduction__c,
                                                                     Opportunity__r.RecordType.Name,ETT_Repair_Price__c,Selling_Procure_Price__c,Selling_Hot_Price__c,ETT_Retread_Hot_Price__c,ETT_Retread_Procure_Price__c,Price_Change_Reason__c from ETT_Staging_Quotation_Request__c where Opportunity__c =:recordId];
        
        return lstStagQuotaionReq;
    }
    @auraEnabled
    public static user getLoggedUserInfo(){
        
        return [select id,Name,Profile.Name from user where id=:userInfo.getUserId()];
    }
    
    
    @AuraEnabled
    public static Map<String, String> getselectOptions(sObject objObject, string fld) {
        
        List < String > allOpts = new list < String > ();
        Map<String, String> options = new Map<String, String>();
        
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
            options.put(a.getValue(), a.getLabel());
        }
        
        allOpts.sort();
        System.debug(options);
        return options;
    }
    
    @AuraEnabled
    public static List<ETT_Tyre_Master__c> getTyreMasterDetails(ID recordId){
        return [SELECT Id,RecordTypes__c,ETT_Country__c,ETT_Pattern__c,ETT_Brand__c,ETT_Tyre_Sizes__c, ETT_Status__c,ETT_Brand_Name__c,ETT_Original_Pattern__c,ETT_Tyre_Size__c,ETT_Country_Name__c, ETT_Brand_Name__r.Name, ETT_Country_Name__r.Name, ETT_Original_Pattern__r.Name, 
                ETT_Tyre_Size__r.Name,  RecordType.Name FROM ETT_Tyre_Master__c where RecordType.Name='Draft' and Opportunity__c=:recordId];
        
        
        
    }
    
    @auraEnabled
    public static list<ETT_Staging_Quotation_Request__c> handleNewTyreDetails(Id recordId,List<ETT_Tyre_Master__c> tyreMastInfo){
        
        list<ETT_Staging_Quotation_Request__c> lstStgQuotation = new list<ETT_Staging_Quotation_Request__c>();
        Savepoint sp = Database.setSavepoint();
        set<id> stgQuotIds = new set<id>();
        
        
        
        /**** Start Tyre Size logic--Check Tyre size master has tyre size, if not create new one in tyre size master ****/
        set<string> newTyreSize = new set<string>();
        map<string,Id> tyreSizeVsId =  new map<string,id>();
        list<ETT_Tyre_Size_Master__c> newTyreSizelist = new  list<ETT_Tyre_Size_Master__c>();
        
        for(ETT_Tyre_Master__c newTyre : tyreMastInfo){
            
            newTyreSize.add(newTyre.ETT_Tyre_Sizes__c);
            
        }            
        for(ETT_Tyre_Size_Master__c ts: [select id,name from ETT_Tyre_Size_Master__c where Name=:newTyreSize]){
            
            tyreSizeVsId.put(ts.Name,ts.Id);
        }
        
        for(string str : newTyreSize){
            
            if(!tyreSizeVsId.containsKey(str)){
                ETT_Tyre_Size_Master__c ts = new ETT_Tyre_Size_Master__c();
                ts.Name = str;
                newTyreSizelist.add(ts);
            }
            
        }
        
        insert newTyreSizelist;
        
        for(ETT_Tyre_Size_Master__c ts: [select id,name from ETT_Tyre_Size_Master__c where Name=:newTyreSize]){
            
            tyreSizeVsId.put(ts.Name,ts.Id);
        }
        /**** End Tyre Size logic ****/
        
        /**** Start Brand logic ****/
        set<string> newBrand = new set<string>();
        map<string,Id> brandVsId =  new map<string,id>();
        list<ETT_Brand_Master__c> newBrandlist = new  list<ETT_Brand_Master__c>();
        
        for(ETT_Tyre_Master__c newTyre : tyreMastInfo){
            
            newBrand.add(newTyre.ETT_Brand__c);
            
        }            
        for(ETT_Brand_Master__c br: [select id,Name from ETT_Brand_Master__c where Name=:newBrand]){
            
            brandVsId.put(br.Name,br.Id);
        }
        
        for(string str : newBrand){
            
            if(!brandVsId.containsKey(str)){
                ETT_Brand_Master__c bm = new ETT_Brand_Master__c();
                bm.Name = str;
                newBrandlist.add(bm);
            }
            
        }
        
        insert newBrandlist;
        
        for(ETT_Brand_Master__c bm: [select id,name from ETT_Brand_Master__c where Name=:newBrand]){
            
            brandVsId.put(bm.Name,bm.Id);
        }
        /**** End Brand logic ****/
        
        /**** Start Pattern logic ****/
        set<string> newPattern = new set<string>();
        map<string,Id> patternVsId =  new map<string,id>();
        list<ETT_Pattern_Master__c> newPatternlist = new  list<ETT_Pattern_Master__c>();
        
        for(ETT_Tyre_Master__c newTyre : tyreMastInfo){
            
            newPattern.add(newTyre.ETT_Pattern__c);
            
        }            
        for(ETT_Pattern_Master__c pr: [select id,Name from ETT_Pattern_Master__c where Name=:newPattern]){
            
            patternVsId.put(pr.Name,pr.Id);
        }
        
        for(string str : newPattern){
            
            if(!patternVsId.containsKey(str)){
                ETT_Pattern_Master__c pm = new ETT_Pattern_Master__c();
                pm.Name = str;
                newPatternlist.add(pm);
            }
            
        }
        
        insert newPatternlist;
        
        for(ETT_Pattern_Master__c bm: [select id,name from ETT_Pattern_Master__c where Name=:newPattern]){
            
            patternVsId.put(bm.Name,bm.Id);
        }
        /**** End pattern logic ****/
        
        
        /**** Start country logic ****/
        set<string> newCountry = new set<string>();
        map<string,Id> countryVsId =  new map<string,id>();
        list<ETT_Country_Master__c> newCountrylist = new  list<ETT_Country_Master__c>();
        
        for(ETT_Tyre_Master__c newTyre : tyreMastInfo){
            
            newCountry.add(newTyre.ETT_Country__c);
            
        }            
        for(ETT_Country_Master__c cm: [select id,Name from ETT_Country_Master__c where Name=:newCountry]){
            
            countryVsId.put(cm.Name,cm.Id);
        }
        
        for(string str : newCountry){
            
            if(!countryVsId.containsKey(str)){
                ETT_Country_Master__c pm = new ETT_Country_Master__c();
                pm.Name = str;
                newCountrylist.add(pm);
            }
            
        }
        
        insert newCountrylist;
        
        for(ETT_Country_Master__c bm: [select id,name from ETT_Country_Master__c where Name=:newCountry]){
            
            countryVsId.put(bm.Name,bm.Id);
        }
        /**** End country logic ****/
        
        //Create New Tyre Master with above details in draft mode
        
        
        for(ETT_Tyre_Master__c newTyre : tyreMastInfo){
            if(newTyre.RecordTypes__c == 'Approve'){
                newTyre.ETT_Tyre_Size__c = tyreSizeVsId.get(newTyre.ETT_Tyre_Sizes__c);
                newTyre.ETT_Brand_Name__c = brandVsId.get(newTyre.ETT_Brand__c);
                newTyre.ETT_Country_Name__c = countryVsId.get(newTyre.ETT_Country__c);
                newTyre.ETT_Original_Pattern__c = patternVsId.get(newTyre.ETT_Pattern__c);
            }
        }
        if(tyreMastInfo.size()>0 && tyreMastInfo != null){
            update tyreMastInfo;
        }
        
        
        for(ETT_Tyre_Master__c ty : tyreMastInfo){
            
            if(ty.RecordTypes__c == 'Approve'){
                ty.RecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Approved').getRecordTypeId();
            }else if(ty.RecordTypes__c == 'Reject'){
                
                ty.RecordTypeId = Schema.SObjectType.ETT_Tyre_Master__c.getRecordTypeInfosByName().get('Reject').getRecordTypeId();
            }
            
            if(ty.RecordTypes__c=='Approve' && ty.ETT_Status__c==true){
                ETT_Staging_Quotation_Request__c objStgQuotation = new ETT_Staging_Quotation_Request__c();
                objStgQuotation.ETT_Tyre_Size_Master__c = ty.ETT_Tyre_Size__c;
                objStgQuotation.ETT_Brand__c = ty.ETT_Brand_Name__c;
                objStgQuotation.ETT_Country__c = ty.ETT_Country_Name__c;
                objStgQuotation.ETT_Pattern__c = ty.ETT_Original_Pattern__c;
                objStgQuotation.ETT_Purchase_Price__c = 0.00;
                objStgQuotation.Opportunity__c = recordId;
                objStgQuotation.RecordTypeId = Schema.SObjectType.ETT_Staging_Quotation_Request__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                
                lstStgQuotation.add(objStgQuotation);
            }   
        }
        try{         
            update tyreMastInfo;
            insert lstStgQuotation;
            for(ETT_Staging_Quotation_Request__c st : lstStgQuotation){
                stgQuotIds.add(st.id);
            }
            return [Select Id,ETT_Min_Range__c,Approver_Status__c,ETT_Max_Range__c,ETT_Purchase_Price__c,ETT_Brand__r.Name,ETT_Pattern__r.Name,ETT_Country__r.Name,ETT_Tyre_Size_Master__r.Name,ETT_Approve_Stage__c,ETT_IS_Approved__c,ETT_Quantity__c,ETT_Rejection_Comments__c,ETT_Retreading_charge__c,ETT_Stock_Retreading_Charge__c,ETT_Tyre_Size_Master__c,ETT_Tyre_Life__c,ETT_Tyre_Condition__c,ETT_Tyre_Process__c,ETT_Reasons_For_Price_Reduction__c
                    from ETT_Staging_Quotation_Request__c where Id =:stgQuotIds];
        }catch(Exception e) {
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());    
        } 
        
    }
    
    @auraEnabled
    public static void updateStgQuotCreatePriceMas(Id recordId,List<ETT_Staging_Quotation_Request__c> stagQuotList,string priceChangeData){
        
        /* Not added quotation rejection criteria condition, if any one quotation rejected updating status in Quotation level 
* If any one quotation is approved, then opp stage is updating
* */
        list<priceChangeWrapper> convertedData = (list<priceChangeWrapper>)JSON.deserialize(priceChangeData,list<priceChangeWrapper>.Class);
        
        
        list<ETT_Pricing_Information__c> newPriceList = new  List<ETT_Pricing_Information__c>();
        User objUser = [SELECT Id,Name,Username,Profile.Name FROM User where Id = :UserInfo.getUserId()];
        Opportunity objOpp = [Select Id,AccountId,RecordType.Name,Account.Party_Type__c  from Opportunity where Id=:recordId];
        list<ETT_Price_Master__c> epm = [select id from ETT_Price_Master__c where ETT_Party_Name__c=:objOpp.AccountId limit 1];
        
        Boolean isApproved = false;//FM
        Boolean isHOOApproved = false;
        Boolean isSalesApproved = false;
        Boolean isRejected = false;
        Id priceMasId;
        
        Savepoint sp = Database.setSavepoint();
        
        for(ETT_Staging_Quotation_Request__c stg : stagQuotList){
            
            if(stg.Approver_Status__c == 'Rejected'){
                stg.ETT_Approve_Stage__c='Rejected';
                isRejected = true;
            }else if(stg.Approver_Status__c == 'Approved' && objUser.Profile.Name=='ETT_Sales Team'){
                
                stg.ETT_Approve_Stage__c='Pending for HOO Approval';
                isSalesApproved=true;
            }           
            else if(stg.Approver_Status__c == 'Approved' && objUser.Profile.Name=='ETT_Head of Operations'){
                
                stg.ETT_Approve_Stage__c='Pending for FM Approval';
                isHOOApproved = true;
                
            }else if(stg.Approver_Status__c == 'Approved' && (objUser.Profile.Name=='ETT_Factory Manager' || test.isRunningTest())){
                
                stg.ETT_Approve_Stage__c='Approved';               
                isApproved = true;
                
            }
            
            
        }
        try{
            
            update stagQuotList;
            
            if(isRejected){
                
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Rejected');
                req.setAction('Reject');
                Id workItemId  = getWorkItemId(recordId); //Opp Id
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);
            }
            
            if(isSalesApproved && !isRejected){
                
                //Approve the approval if User has Sales profile
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approved By Sales Team');
                req.setAction('Approve');
                Id workItemId  = getWorkItemId(recordId); //Opp Id
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);
            }
            
            if(isHOOApproved && !isRejected){
                
                //Approve the approval if User has Hoo profile
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approved By HOO');
                req.setAction('Approve');
                Id workItemId  = getWorkItemId(recordId); //Opp Id
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);
            }
            
            
            if(isApproved && !isRejected){ //FM 
                
                
                if(epm.size()> 0 && epm[0].Id != null){
                    priceMasId = epm[0].Id;
                    system.debug('---if--');
                }else{
                    system.debug('---else--');
                    ETT_Price_Master__c ep = new ETT_Price_Master__c();
                    ep.Opportunity__c = recordId;
                    ep.ETT_Party_Name__c = objOpp.AccountId;
                    if(objOpp.RecordType.Name =='Tyre Refurbishing Services'){
                        ep.RecordTypeId = Schema.SObjectType.ETT_Price_Master__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
                    }else{
                        ep.RecordTypeId = Schema.SObjectType.ETT_Price_Master__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                    }
                    ep.ETT_Price_Information_External_Id__c =  objOpp.AccountId+objOpp.Account.Party_Type__c;
                    ep.ETT_Party_Type__c = objOpp.Account.Party_Type__c;
                    insert ep;
                    
                    priceMasId= ep.Id;
                }
                
                
                
                for(ETT_Staging_Quotation_Request__c stg : stagQuotList){
                    ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();	
                    epi.ETT_Price__c = priceMasId;
                    epi.ETT_Approval_Status__c ='Approved';
                    epi.ETT_Purchase_Price__c = stg.ETT_Purchase_Price__c;
                    epi.ETT_Repair_Price__c = stg.ETT_Repair_Price__c;
                    epi.ETT_Selling_Price_P__c= stg.Selling_Procure_Price__c;
                    epi.ETT_Selling_Price_H__c= stg.Selling_Hot_Price__c;
                    epi.ETT_Retread_Price_H__c= stg.ETT_Retread_Hot_Price__c;
                    epi.ETT_Retread_Price_P__c= stg.ETT_Retread_Procure_Price__c;
                    epi.ETT_Minimum_Price__c = stg.ETT_Min_Range__c;
                    epi.ETT_Maximum_Price__c = stg.ETT_Max_Range__c;
                    if(objOpp.RecordType.Name =='Tyre Refurbishing Services'){
                        
                        epi.RecordTypeId = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                        
                    }else{
                        epi.RecordTypeId = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
                        
                    }
                    epi.ETT_Brand__c = stg.ETT_Brand__c;
                    epi.ETT_Pattern__c = stg.ETT_Pattern__c;
                    epi.ETT_Country_of_Origin__c = stg.ETT_Country__c;
                    epi.ETT_Tyre_Size__c = stg.ETT_Tyre_Size_Master__c;
                    epi.Staging_Quotation_Request__c=stg.Id;
                    newPriceList.add(epi);
                }
                
                insert newPriceList;
                
                //Approve the approval if User has FM profile
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approved by FM');
                req.setAction('Approve');
                Id workItemId  = getWorkItemId(recordId); //Opp Id
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);
                
            } 
            if(convertedData.size()>0){
                String htmlBody = '';
                
                htmlBody ='<p>Dear FM,</p><p>Please find below price change details.Click below link to access the Opportunity.</p><p>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+recordId+'</p>';
                htmlBody += '<table border="1" style="border-collapse: collapse"><tr><th>Tyre Size</th><th>Old Repair Price</th><th>New Repair Price</th><th>Old Selling Procure Price</th><th>New Selling Procure Price</th>';
                htmlBody += '<th>Old Selling Hot Price</th><th>New Selling Hot Price</th><th>Old Retread Procure Price</th><th>New Retread Procure Price</th><th>Old Retread Hot Price</th><th>New Retread Hot Price</th><th>Price Change Reason</th></tr>';
                
                for(priceChangeWrapper ob : convertedData){
                    
                    htmlBody += '<tr><td>' + ob.tyreSize + '</td><td>' + ob.OldRepairPrice + '</td><td>' + ob.NewRepairPrice + '</td><td>' + ob.OldSelProPrice + '</td><td>' + ob.NewSelProPrice + '</td><td>';
                    htmlBody +=  ob.OldSelHotPrice + '</td><td>' + ob.NewSelHotPrice + '</td><td>' + ob.OldRetProPrice + '</td><td>' + ob.NewRetProPrice + '</td><td>';
                    htmlBody +=  ob.OldRetHotPrice + '</td><td>' + ob.NewRetHotPrice + '</td><td>' + ob.reason + '</td></tr>';
                    
                }
                htmlBody += '</table>';
                htmlBody += '<p>Note: This is system generated notification.</p>';
                
                list<string> emailList = new list<string>();
                for(user u : [select id,email from user where profile.name='ETT_Factory Manager']){
                    emailList.add(u.email);
                }
                OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName ='Emirates Transport'];
                
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(emailList);
                mail.setHtmlBody(htmlBody);
                if (owea.size() > 0) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mail.setSubject('Customer Price Change Notification');
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new list<Messaging.SingleEmailMessage>{mail});  
            }
        }catch(System.DmlException e) {
            Database.rollback(sp);
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());
            throw new AuraHandledException(e.getMessage());   
            
        }
        
    }
    public class priceChangeWrapper{
        public string tyreSize;
        public Decimal NewRepairPrice;
        public Decimal OldRepairPrice;
        public Decimal NewSelProPrice;
        public Decimal OldSelProPrice;
        public Decimal NewSelHotPrice;
        public Decimal OldSelHotPrice;
        public Decimal NewRetProPrice;
        public Decimal OldRetProPrice;
        public Decimal NewRetHotPrice;
        public Decimal OldRetHotPrice;
        public string reason;
        
    }
    
    public static Id getWorkItemId(Id targetObjectId) {
        
        Id retVal = null;
        
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p 
                                                 where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }
        
        return retVal;
    }
    
}