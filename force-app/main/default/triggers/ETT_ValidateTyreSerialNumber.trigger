trigger ETT_ValidateTyreSerialNumber on ETT_Inspection_Card__c (before insert,before update,after Update) {
    
    if(Trigger.isBefore){
       /* if(Trigger.isInsert){
            
            List<ETT_Inspection_Card__c> lstIC = [select Id,ETT_Tyre_Serial_Number__c ,ETT_Brand__c from ETT_Inspection_Card__c];
            
            for(ETT_Inspection_Card__c ic: trigger.new ){
                
                boolean match = false;  
                for(ETT_Inspection_Card__c existingIcRecords:lstIC){
                    
                    if(ic.ETT_Tyre_Serial_Number__c==existingIcRecords.ETT_Tyre_Serial_Number__c && ic.ETT_Brand__c ==existingIcRecords.ETT_Brand__c )
                    {
                        match = true;
                        break; 
                    }
                }
                
                if(match)
                {
                    ic.adderror('Duplicate Serial number and Brand is present.Please enter Different Serial number or Brand');
                }
            }
        } */       
       /* if(Trigger.isUpdate){
            Map<id,String> newTyreDetailMap =new  Map<id,String>();  
            
            for(ETT_Inspection_Card__c ic: trigger.new ){
                if(trigger.oldMap.containsKey(ic.id))
                {
                    if(trigger.oldMap.get(ic.id).ETT_Tyre_Serial_Number__c!= ic.ETT_Tyre_Serial_Number__c||
                       trigger.oldMap.get(ic.id).ETT_Brand__c!= ic.ETT_Brand__c)
                    {
                        String Value = ic.ETT_Tyre_Serial_Number__c+'#'+ic.ETT_Brand__c;
                        newTyreDetailMap.put(ic.id,Value); 
                    } 
                }
            }
            List<ETT_Inspection_Card__c> lstIC = [select Id,ETT_Tyre_Serial_Number__c ,ETT_Brand__c from
                                                  ETT_Inspection_Card__c];
            System.debug('begin =');
            Set<Id> errorIds = new Set<Id>();
            for(ETT_Inspection_Card__c ic:lstIC){
                
                if(!newTyreDetailMap.containsKey(ic.Id))
                {
                    for(Id newTyreId:newTyreDetailMap.keySet())
                    {
                        // System.debug('map found key='+ic.id);
                        String parameters=  newTyreDetailMap.get(newTyreId);
                        List<String> paramlst=parameters.split('#');
                        String newserialno=paramlst[0];
                        String newbrandname=paramlst[1];
                        // System.debug('newserialno'+newserialno);
                        //   System.debug('newbrandname'+newbrandname);
                        if(newserialno!=null&& newserialno!=''&& newserialno==ic.ETT_Tyre_Serial_Number__c && newbrandname!=null&& newbrandname!=''&&  newbrandname==ic.ETT_Brand__c ){
                            System.debug('add as error'); 
                            System.debug(' dupliated record'+ic.id);
                            // ic.adderror('duplicate Serial number and Brand is present.Please enter Different Serial number and Brand');
                            errorIds.add(newTyreId);
                        }
                    } 
                }
            }
            for(ETT_Inspection_Card__c newInsectionCard:Trigger.new)
            {
                if(errorIds.contains(newInsectionCard.id))
                {
                    newInsectionCard.adderror('Duplicate Serial number and Brand is present.Please enter Different Serial number or Brand');
                }
                
            }
        }
        
        /*
if(Trigger.isUpdate){

String oldStatus;
String newStatus;
ID icID;

for(ETT_Inspection_Card__c ic : Trigger.New){

ETT_Inspection_Card__c oldIc = Trigger.oldMap.get(ic.Id);

oldStatus = oldIc.ETT_Status__c;
newStatus = ic.ETT_Status__c;
icID = ic.Id;
}

List<ETT_Estimate_Quotation__c> lstEStQuote = [SELECT Id,ETT_Tyre_Inspection_Card__c,ETT_Status__c from ETT_Estimate_Quotation__c where ETT_Tyre_Inspection_Card__c=:icID];

if(lstEStQuote!=null && lstEStQuote.size()>0){
if(lstEStQuote[0].ETT_Status__c == 'Accepted' && oldStatus != newStatus){
//ic.addError('test');
}
}


}
*/
    }
    if(Trigger.isAfter){
       /* if(Trigger.isUpdate){
            List<ETT_Tyre_Master__c> tyremasterList = [Select id,ETT_Brand_Name__c,ETT_Country_Name__c,ETT_Original_Pattern__c,ETT_Tyre_Size__c from ETT_Tyre_Master__c];
            List<ETT_Tyre_Master__c> insertTyreMasterList = new List<ETT_Tyre_Master__c>();
            List<ETT_Pricing_Information__c> newPricingInformationList = new List<ETT_Pricing_Information__c>();
            for(ETT_Inspection_Card__c ins:Trigger.New){
                Id accId = ins.ETT_Account__c;
                Id updatedTyreSize = ins.ETT_Tyre_Size__c;
                Id updatedBrand = ins.ETT_Brand__c;
                Id updatedPattern = ins.ETT_Pattern__c;
                Id updatedCountry = ins.ETT_Country__c;
                boolean matchinTyreMaster = false;
                for(ETT_Tyre_Master__c tyremaster:tyremasterList)
                {
                    if(tyreMaster.ETT_Brand_Name__c==updatedBrand&&tyreMaster.ETT_Tyre_Size__c==updatedTyreSize&&tyreMaster.ETT_Country_Name__c==updatedCountry&&tyreMaster.ETT_Original_Pattern__c==updatedPattern) 
                    {
                        matchinTyreMaster = true;
                        break;
                    }
                    
                }
                if(!matchinTyreMaster)
                {
                    ETT_Tyre_Master__c tym = new ETT_Tyre_Master__c();
                    tym.ETT_Brand_Name__c = updatedBrand;
                    tym.ETT_Tyre_Size__c = updatedTyreSize;
                    tym.ETT_Country_Name__c = updatedCountry;
                    tym.ETT_Original_Pattern__c = updatedPattern;
                    //  tym.ETT_Vehicle_Type__c = 'Bus';
                    
                    insertTyreMasterList.add(tym);
                }
                List<ETT_Price_Master__c>  priceMaster = [Select id,Name,(Select id ,name,ETT_Brand__c,ETT_Pattern__c,ETT_Tyre_Size__c,ETT_Country_of_Origin__c from Pricing_Information__r) from ETT_Price_Master__c where ETT_Party_Name__c =: accId ];
                
                if(priceMaster.size()>0)
                {
                    System.debug('price master present');
                    //String priceMasterRecordType = priceMaster[0].RecordType.name;
                   // System.debug('priceMasterRecordType='+priceMasterRecordType);
                    Boolean Match = false;
                 
                    
                    if(!Match)
                    {
                        System.debug('not matched..creating pricing infromation');
                        ETT_Pricing_Information__c pinfo = new ETT_Pricing_Information__c();
                        //Id pricingInformationRecordType = Schema.SObjectType.ETT_Pricing_Information__c.getRecordTypeInfosByName().get(priceMasterRecordType).getRecordTypeId();
                        //System.debug('record type id pinfo = '+pricingInformationRecordType);
                        pinfo.ETT_Brand__c = updatedBrand;
                        pinfo.ETT_Pattern__c = updatedPattern;
                        pinfo.ETT_Tyre_Size__c = updatedTyreSize;
                        pinfo.ETT_Country_of_Origin__c = updatedCountry;
                        //pinfo.RecordTypeId = pricingInformationRecordType;
                        pinfo.ETT_Price__c = priceMaster[0].id;
                        pinfo.ETT_Purchase_Price__c = 0.00;
                        
                        newPricingInformationList.add(pinfo);
                        
                        //  insert pinfo;
                        
                        
                    }
                    
                    
                }
            }
            System.debug('insertTyreMasterList = '+ insertTyreMasterList);
            if(insertTyreMasterList.size()>0)
            {
                insert insertTyreMasterList;
            }
            System.debug('newPricingInformationList = '+ newPricingInformationList);
            if(newPricingInformationList.size()>0)
            {
                insert newPricingInformationList;
                
                for(ETT_Pricing_Information__c pinfo:newPricingInformationList)
                {
                    CustomNotificationType notificationType = [SELECT Id, DeveloperName
                                                               FROM CustomNotificationType
                                                               WHERE DeveloperName='ETT_Notification'];
                    
                    // Create a new custom notification
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    
                    // Set the contents for the notification
                    notification.setTitle('New Pricing Information Record is created. Please change purchase price.');
                    notification.setBody('New Pricing Information Record is created. Please change purchase price.');
                    
                    // Set the notification type and target
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetId(pinfo.Id);
                    //PageReference orderPage = new PageReference('/ETT_Material_Requisition_Approval');
                    //String pgRef = '{ type: "standard__navItemPage",attributes:{apiName:ETT_Material_Requisition_Approval}}';
                    //notification.setTargetPageRef(pgRef);
                    
                    Set<String> addressee = new Set<String>();
                    List<User> cashierUser =[SELECT Id, name,profile.name from user where profile.name='ETT_Head of Operations'];
                    system.debug('cashierUser== '+cashierUser);
                    addressee.add(cashierUser[0].Id);
                    system.debug('notification=='+notification);
                    // Actually send the notification
                    try {
                        notification.send(addressee);
                    }
                    catch (Exception e) {
                        System.debug('Problem sending notification: ' + e.getMessage());
                    }
                    System.debug('successfully inserted pricing infromation ');
                }
            }
        }
        set<Id> setCollectionCard = new set<id>();
        Map<Id,List<ETT_Inspection_Card__c>> vMapCCIC = new Map<Id,List<ETT_Inspection_Card__c>>();
        List<ETT_Collection_Card__c> vListCC = new List<ETT_Collection_Card__c>();
        Boolean vFlag = false;
        for(ETT_Inspection_Card__c  vItm : trigger.new){
            setCollectionCard.add(vItm.ETT_Collection_Card__c);
        }
        if(setCollectionCard.size() >0){
        list<ETT_Inspection_Card__c> vICList = [select Id, ETT_Status__c,ETT_Collection_Card__c from ETT_Inspection_Card__c where ETT_Collection_Card__c IN :setCollectionCard];
      	for(ETT_Inspection_Card__c vItm : vICList){
            if(!vMapCCIC.containsKey(vItm.ETT_Collection_Card__c))
                vMapCCIC.put(vItm.ETT_Collection_Card__c,new List<ETT_Inspection_Card__c>());
            vMapCCIC.get(vItm.ETT_Collection_Card__c).add(vItm);
        }
            
            for(Id vItm : vMapCCIC.keySet()){
                
                for(ETT_Inspection_Card__c vItm2 : vMapCCIC.get(vItm)){
                    if(vItm2.ETT_Status__c == 'Accept' || vItm2.ETT_Status__c == 'Send Back' ){
                        vFlag = true;
                    }
                    else{
                        vFlag = false;
                        break;
                    }
                }
                if(vFlag){
                    ETT_Collection_Card__c objCollectionCard = new ETT_Collection_Card__c();
                	objCollectionCard.Id = vItm;
                	objCollectionCard.ETT_Inspection_Done__c = true; 
                    vListCC.add(objCollectionCard);
                }
            }
            System.debug('Done--->'+vListCC);
            if(vListCC.size() > 0)
                update vListCC;
        } */   
    }
}