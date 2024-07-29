@isTest
public class ETT_workStationCheckListHelperTest {
    
    public static testmethod void notifyUserTest(){
        
        ETT_Work_Station__c ws = new ETT_Work_Station__c();
        ws.ETT_Station_Type__c ='Curing';
        ws.ETT_Station_Code__c='CUR001';
        insert ws;
        
        ETT_Work_Schedule__c wsc = new ETT_Work_Schedule__c();
        wsc.ETT_Start_time__c = system.today();
        wsc.ETT_End_time__c =  system.today()+2;
        wsc.ETT_Work_Station__c = ws.Id;
        wsc.ETT_Technician__c = userinfo.getUserId();
        insert wsc;
        
        ETT_Work_Station_Checklist__c ch = new ETT_Work_Station_Checklist__c();
        ch.Work_Schedule__c = wsc.Id;
        ch.Work_Station__c = ws.Id;
        ch.Door_Safety_Lock_Condition__c ='Not Good';
        ch.x13_Inflation_Pressure__c = 'Not Good';
        ch.X13_Pressure_Cable_Condition__c = 'Not Good';
        ch.X13_Vacuum_Pressure_Valve_Condition__c='Not Good';
        ch.Digital_Screen_Condition__c ='Not Good';
        ch.Control_Panel_Board_Condition__c ='Not Good';
        ch.Chamber_Motor_Condition__c ='Not Good';
        ch.Gaugs_Vacuum_Pressure_Condition__c ='Not Good';
        insert ch;
    }

}