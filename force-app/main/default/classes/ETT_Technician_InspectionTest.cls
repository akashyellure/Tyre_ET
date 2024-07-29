@isTest
public class ETT_Technician_InspectionTest {
    
    @isTest
    public static void testcase1(){
        Test.startTest();
        List < String > result =ETT_Technician_Inspection.getselectOptions();
        ETT_Technician_Inspection.savefile();
        Test.stopTest();
        System.assert(result != null);
    }
}