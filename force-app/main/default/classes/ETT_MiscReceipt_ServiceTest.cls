@isTest
public class ETT_MiscReceipt_ServiceTest {
    static testmethod void ETT_MiscReceipt_Service(){
        ETT_MiscReceipt_Service.SyncCreateMiscellaneousReceiptsServiceBPEL_pt msrpt = new ETT_MiscReceipt_Service.SyncCreateMiscellaneousReceiptsServiceBPEL_pt();
    	ETT_MiscReceipt.MessageXml msgXml = new ETT_MiscReceipt.MessageXml();
        try{
            msrpt.process(msgXml);
        }catch(Exception e){}
    }
    static testmethod void ETT_MiscIssue_Service(){
        ETT_MiscIssue_Service.SyncCreateMiscellaneousIssuesServiceBPEL_pt msrpt = new ETT_MiscIssue_Service.SyncCreateMiscellaneousIssuesServiceBPEL_pt();
    	ETT_MiscIssues.MessageXml msgXml = new ETT_MiscIssues.MessageXml();
        try{
            msrpt.process(msgXml);
        }catch(Exception e){}
    }
    static testmethod void ETT_InterOrgTransfer_Service(){
        ETT_InterOrgTransfer_Service.SyncInterOrgTransfersServiceBPEL_pt msrpt = new ETT_InterOrgTransfer_Service.SyncInterOrgTransfersServiceBPEL_pt();
    	ETT_InterOrgTransfer_DeliveryNote.MessageXml msgXml = new ETT_InterOrgTransfer_DeliveryNote.MessageXml();
        try{
            msrpt.process(msgXml);
        }catch(Exception e){}
    }

}