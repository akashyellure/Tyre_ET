/**
 * Author:Janardhan
 * CreatedDate: 19-05-2022
 * TestCls: ETT_Acc_CustomLkupCtrlTest
 * */
public class ETT_Acc_CustomLkupCtrl {
    
     @AuraEnabled
    public static list<account> getAcctFilterList(string searchWord){
        
        String queryStr;
        queryStr = 'SELECT Id,Name from Account where Name LIKE  \'%'+ searchWord +'%\' AND recordType.Name =\'Organization\' limit 5';
       
        return Database.Query(queryStr);
    }

}