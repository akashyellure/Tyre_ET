@isTest 
public class ETT_GoodsIssueNoteTriggerHandler_Test {
    public static testmethod void goodsIssueNote_Test(){
        
        ETT_Goods_Issue_Note__c goodIssue = new ETT_Goods_Issue_Note__c();
        goodIssue.Misc_Issue_Err_Msg__c = 'test issue error msg';
        goodIssue.Misc_Issue_Status__c = 'Success';
        goodIssue.Request_Body__c = 'test Request body';
        goodIssue.Issue_Type__c= 'Factory';
        goodIssue.Status__c = 'Approved';
        insert goodIssue;
        
        goodIssue.Request_Body__c = 'test Request body in good issue note.';
        update goodIssue;
        
        ETT_Tools_Master__c toolMaster = new ETT_Tools_Master__c();
        toolMaster.ETT_Serial_No__c = 'sr12';
        insert toolMaster;
        
        ETT_Goods_Issue_Lines__c gIssueLine = new ETT_Goods_Issue_Lines__c();
        gIssueLine.Goods_Issue_Note__c = goodIssue.id;
        gIssueLine.Issued_Quantity__c = 12;
        gIssueLine.Tool_Material_Name__c = toolMaster.id;
        insert gIssueLine;
        
    }
  @testSetup
    static void setup() {
        // Create test data for ETT_Tools_Master__c
        List<ETT_Tools_Master__c> toolsList = new List<ETT_Tools_Master__c>();
        for (Integer i = 0; i < 5; i++) {
            ETT_Tools_Master__c tool = new ETT_Tools_Master__c(
                Name = 'Tool ' + i,
                ETT_Main_Stock_Units__c = 100,
                ETT_Allocated_Units__c = 0
            );
            toolsList.add(tool);
        }
        insert toolsList;

        // Create test data for ETT_Goods_Issue_Note__c
        List<ETT_Goods_Issue_Note__c> goodsIssueNotes = new List<ETT_Goods_Issue_Note__c>();
        for (Integer i = 0; i < 3; i++) {
            ETT_Goods_Issue_Note__c gin = new ETT_Goods_Issue_Note__c(
                Misc_Issue_Err_Msg__c = 'test issue error msg',
                Misc_Issue_Status__c = 'Success',
                Request_Body__c = 'test Request body',
                Issue_Type__c= 'Factory',
                Status__c = 'New'
            );
            goodsIssueNotes.add(gin);
        }
        insert goodsIssueNotes;

        // Create test data for ETT_Goods_Issue_Lines__c
        List<ETT_Goods_Issue_Lines__c> goodsIssueLines = new List<ETT_Goods_Issue_Lines__c>();
        for (ETT_Goods_Issue_Note__c gin : goodsIssueNotes) {
            for (ETT_Tools_Master__c tool : toolsList) {
                ETT_Goods_Issue_Lines__c gil = new ETT_Goods_Issue_Lines__c(
                    Goods_Issue_Note__c = gin.Id,
                    Tool_Material_Name__c = tool.Id,
                    Issued_Quantity__c = 10
                );
                goodsIssueLines.add(gil);
            }
        }
        insert goodsIssueLines;
    }

    @isTest
    static void testUpdateQuantityInToolMaster() {
        // Fetch the test data
        List<ETT_Goods_Issue_Note__c> lstNew = [SELECT Id, Status__c FROM ETT_Goods_Issue_Note__c];
        Map<Id, ETT_Goods_Issue_Note__c> trgNewMap = new Map<Id, ETT_Goods_Issue_Note__c>();
        
        for (ETT_Goods_Issue_Note__c gin : lstNew) {
            trgNewMap.put(gin.Id, gin);
        }

        // Update status to Approved to trigger the condition
        for (ETT_Goods_Issue_Note__c gin : lstNew) {
            gin.Status__c = 'Approved';
        }
        update lstNew;

        // Call the method to be tested
        Test.startTest();
        ETT_GoodsIssueNoteTriggerHandler.updatequantityintoolmaster(lstNew, trgNewMap); 
        Test.stopTest();

     
    }

    @isTest
    static void testNoUpdateIfStatusNotApproved() {
        // Fetch the test data
        List<ETT_Goods_Issue_Note__c> lstNew = [SELECT Id, Status__c FROM ETT_Goods_Issue_Note__c];
        Map<Id, ETT_Goods_Issue_Note__c> trgNewMap = new Map<Id, ETT_Goods_Issue_Note__c>();
        
        for (ETT_Goods_Issue_Note__c gin : lstNew) {
            trgNewMap.put(gin.Id, gin);
        }

        // Call the method to be tested without changing status
        Test.startTest();
        ETT_GoodsIssueNoteTriggerHandler.updatequantityintoolmaster(lstNew, trgNewMap);  
        Test.stopTest();

        // Verify the results
        List<ETT_Tools_Master__c> updatedTools = [SELECT Id, ETT_Main_Stock_Units__c, ETT_Allocated_Units__c FROM ETT_Tools_Master__c];

        for (ETT_Tools_Master__c tool : updatedTools) {
            System.assertEquals(100, tool.ETT_Main_Stock_Units__c, 'The main stock units should not change');
            System.assertEquals(0, tool.ETT_Allocated_Units__c, 'The allocated units should not change');
        }
    }
    
    
}