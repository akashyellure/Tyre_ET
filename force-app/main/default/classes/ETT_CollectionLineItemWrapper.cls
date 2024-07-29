/*
Created By:G.Krishnareddy
Created Date:03/09/2020
Description : This is for Creating the Collection Line Item based 
upon Price Master and Pricing Information for an Account.
*/
Public class ETT_CollectionLineItemWrapper {
    @Auraenabled public ETT_Pricing_Information__c objPricingInfo;
    @Auraenabled public ETT_Tyre_Master__c objTyreSizeMaster;
    public ETT_CollectionLineItemWrapper(){
    }
}