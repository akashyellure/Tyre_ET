/*
Created By:Shweta
Created Date:27/05/2020
Description : This is for Scrap Analasis Wrppaer to identify the File Names .
*/

global class ETT_SrabTyreWrapper {

    @AuraEnabled public string strKey;
    @AuraEnabled public list<ContentDocument> lstDocuments;

    public void sum(){
        String abc;
        abc = 'Test';
        System.debug('strKey: '+strKey);
        System.debug('lstDocuments: '+lstDocuments);
    }
}