@isTest
public class ETT_DeliveryNotePrintUtilityTest {
    
    @isTest
    public static void testCase1(){
        Account objAcc1 = new Account();
        objAcc1.Name = 'First Account';
        insert objAcc1;
        Contact con=new Contact();
        con.LastName = 'Test';
        con.AccountId=objAcc1.id;
        insert con;
        ETT_Collection_Card__c ett_collection_card = new ETT_Collection_Card__c(
            CurrencyIsoCode = 'AED',
            ETT_Accounts__c = objAcc1.id,
            ETT_All_Tyre_Rejected__c = false,
            ETT_CCL_Created__c = false,
            ETT_Check_In__c = DateTime.newInstance(2020,12,14,7,439,26392),
            ETT_Check_Out__c = DateTime.newInstance(2020,12,14,7,440,26438),
            ETT_Collection_Date__c = Date.newInstance(2020,12,07),
            ETT_Collection_Status__c = 'Accepted',
            ETT_Collection_Team_Submitted__c = true,
            ETT_Completed__c = false,
            ETT_Create_Job_Card__c = false,
            ETT_Estimation_Completed_By_Fm__c = false,
            ETT_Estimation_Completed_By_HOO__c = false,
            ETT_Factory_Manager_Approved__c = false,
            ETT_Head_Of_Operation_Approved__c = false,
            ETT_Inspection_Done__c = true,
            ETT_Job_Card_Done__c = false,
            ETT_Location__c = 'Dubai',
            ETT_Receptionist_Acceptance__c = false,
            ETT_Sales_Acceptance__c = false,
            //ETT_Status__c = 'Send Back',
            ETT_Submitted_For_Approval__c = false,
            ETT_Is_Active__c = false);
        
        insert ett_collection_card;
        
        ETT_Inspection_Card__c ett_inspection_card = new ETT_Inspection_Card__c(
            CurrencyIsoCode = 'AED',
            ETT_Account__c = objAcc1.id,
            ETT_Chalk_Crayon_Yellow__c = true,
            ETT_Collection_Card__c = ett_collection_card.id,
            ETT_Contact__c = con.id,
            ETT_Cutting_Player__c = true,
            ETT_Electrical_Prob_In_Working_Condition__c = true,
            ETT_Handheld_Drop_Light__c = true,
            ETT_Industrial_Vacuum_Cleaner__c = true,
            ETT_Knife__c = true,
            ETT_Nail_Remover__c = true,
            ETT_Poking_Screwdriver__c = true,
            ETT_Spiral_Cement_Tool__c = true,
            ETT_Spreader_Light_Condition__c = true,
            ETT_Staple_Gun__c = true,
            ETT_Status__c = 'Send Back',
            ETT_Tyre_Life__c = '1',
            ETT_Tyre_Lift_In_Working_Condition__c = true,
            ETT_Tyre_Serial_Number__c = '1234',
            ETT_Tyre_Spreader_In_Working_Condition__c = true,
            ETT_Tyre_Tapping_Tool__c = true);
        
        insert ett_inspection_card;
        
        ETT_Delivery_Note__c ett_delivery_note = new ETT_Delivery_Note__c(
            CurrencyIsoCode = 'AED',
            ETT_Account__c = objAcc1.id,
            ETT_Is_Delivery_Appointment_Booked__c = false,
        ETT_Collection_Card__c = ett_collection_card.id,
        Approved_By__c = userinfo.getUserId());
		
        insert ett_delivery_note;
        Test.startTest();
        ETT_DeliveryNotePrintUtility.fetchDeliveryNotes(objAcc1.id);
        Test.stopTest();
    }
}