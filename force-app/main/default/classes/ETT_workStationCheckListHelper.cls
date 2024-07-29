/*Author: Janardhan Muddana
 * CreatedDate: 01-02-2022
 * Test Class:ETT_workStationCheckListHelperTest
 * 
 * */
public class ETT_workStationCheckListHelper {
    
    
    public static void notifyUsers(map<id,ETT_Work_Station_Checklist__c> trgNew){
        
        set<string> emailSet = new set<string>(); 
        //emailSet.add('janardhan.m@smaartt.com');
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>(); 
        map<string,id> tempDevNameVsTempId = new map<string,id>();
        
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
 
        for(user u : [select id,name,email from user where Isactive=True AND (profile.Name='ETT_Supervisor' OR profile.Name='ETT_Head of Operations')]){
           emailSet.add(u.email);
        }
        
        for(EmailTemplate tem : [SELECT Id,Subject,Body,HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName LIke 'ETT_%']){
            tempDevNameVsTempId.put(tem.DeveloperName,tem.Id);
        }
        
        
        for(ETT_Work_Station_Checklist__c ws : trgNew.values()){
            
            //Curing Door Safety Condtion
            if(ws.Door_Safety_Lock_Condition__c =='Not Good'){
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tempDevNameVsTempId.get('ETT_Curing_DoorSafetyLock'),null,ws.Id);
                
                email.toAddresses = new list<string>(emailSet);
                email.setSubject('Curing - Door safety lock notification');
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                email.setSaveAsActivity(false);
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                emailList.add(email);
            }
            //Curing 13 inflation pressure check
            if(ws.x13_Inflation_Pressure__c =='Not Good'){
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tempDevNameVsTempId.get('ETT_Curing_13InflationPressure'),null,ws.Id);
                
                email.toAddresses = new list<string>(emailSet);
                email.setSubject('Curing - 13 Inflation Pressure');
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                email.setSaveAsActivity(false);
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                emailList.add(email);
            }
             //Curing 13 vacuum pressure valve check
            if(ws.X13_Vacuum_Pressure_Valve_Condition__c =='Not Good'){
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tempDevNameVsTempId.get('ETT_Curing_13VaccumPressureValve'),null,ws.Id);
                
                email.toAddresses = new list<string>(emailSet);
                email.setSubject('Curing - 13 Vacuum Pressure valve');
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                email.setSaveAsActivity(false);
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                emailList.add(email);
            }
             //Curing 13 pressure cable cond check
            if(ws.X13_Pressure_Cable_Condition__c =='Not Good'){
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tempDevNameVsTempId.get('ETT_Curing_13PressureCableCond'),null,ws.Id);
                
                email.toAddresses = new list<string>(emailSet);
                email.setSubject('Curing - 13 Pressure Cable Condition');
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                email.setSaveAsActivity(false);
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                emailList.add(email);
            }
            //Curing digital screen cond
            if(ws.Digital_Screen_Condition__c =='Not Good'){
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tempDevNameVsTempId.get('ETT_Curing_DigiScreenCond'),null,ws.Id);
                
                email.toAddresses = new list<string>(emailSet);
                email.setSubject('Curing - Digital screen Condition');
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                email.setSaveAsActivity(false);
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                emailList.add(email);
            }
            //Curing control panel board cond
            if(ws.Control_Panel_Board_Condition__c =='Not Good'){
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tempDevNameVsTempId.get('ETT_Curing_CtrlPanelBoard'),null,ws.Id);
                
                email.toAddresses = new list<string>(emailSet);
                email.setSubject('Curing - Control panel board Condition');
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                email.setSaveAsActivity(false);
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                emailList.add(email);
            }
            //Curing Chamber motor cond
            if(ws.Chamber_Motor_Condition__c =='Not Good'){
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tempDevNameVsTempId.get('ETT_Curing_ChamberMotorCond'),null,ws.Id);
                
                email.toAddresses = new list<string>(emailSet);
                email.setSubject('Curing - Chamber motor Condition');
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                email.setSaveAsActivity(false);
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                emailList.add(email);
            }
            //Curing Chamber motor cond
            if(ws.Gaugs_Vacuum_Pressure_Condition__c =='Not Good'){
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tempDevNameVsTempId.get('ETT_Curing_GaugesVacPressure'),null,ws.Id);
                
                email.toAddresses = new list<string>(emailSet);
                email.setSubject('Curing - Gauges of vacuum pressure Condition');
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                email.setSaveAsActivity(false);
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                emailList.add(email);
            }
            
        }
        
        try{            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        }Catch(Exception e){
            system.debug('wrkStCheckListHelp--'+e.getMessage());
        }
        
    }

}