public class ETT_QuotationPrintPageCtrl {
    
    public Id recordId {get;set;}
    public Id AccId {get;set;}
    public Account accountInfo {get;set;}
    public ETT_Quotation__c quotation  {get;set;}
    public double total { get; set; }        
    public double vat { get; set; }     
    public double totalAmount { get; set; } 
    public List<ETT_Quotation_Line_Item__c> quotLines{get;set;}
    public string collCards { get; set; }
    public string collCardsDates { get; set; }
	public List<AggregateResult> aglist{get;set;}
    public List<AggregateResult> processedAglist { get; set; }
    
    public ETT_QuotationPrintPageCtrl(ApexPages.StandardController controller){
        recordId = controller.getRecord().Id;  
        AccId = apexpages.currentpage().getparameters().get('AccId');
		aglist =New List<AggregateResult>(); 
        processedAglist = new List<AggregateResult>();

		aglist =[SELECT Tyre_Size_New__c Si,ETT_Job_Type__c jb,ETT_Status__c st,MAX(ETT_Unit_Price__c) up,Count (id) ct,SUM(ETT_Total_Price__c) tp FROM ETT_Quotation_Line_Item__c WHERE ETT_Quotation__c =:recordId Group by Tyre_Size_New__c,ETT_Job_Type__c,ETT_Status__c]; 
        List<AggregateResult> sendBackList = new List<AggregateResult>();
        for (AggregateResult ar : aglist) {
            if ((String) ar.get('st') == 'Send Back') {
                sendBackList.add(ar);
            } else {
                processedAglist.add(ar);
            }
        }
          // Add all "Send Back" records at the end
          processedAglist.addAll(sendBackList);

        accountInfo = [select Id,Name,BillingStreet,ETT_Payment_Term__c,Phone,CreatedBy.FirstName,CreatedBy.Name,CreatedBy.Email,CreatedBy.MobilePhone,Fax,(select id,lastname,Email from contacts) from Account where Id =:AccId]; 
        quotation = [SELECT Id,Name,Claim_Amount__c,(SELECT Id,ETT_Tyre_Size_Name__c,ETT_Account__c,ETT_Job_Type__c,ETT_Unit_Price__c,ETT_Status__c,ETT_Quantity__c,ETT_Total__c,ETT_Total_Price__c FROM Quotation_Line_Items__r order by ETT_Status__c) FROM ETT_Quotation__c WHERE Id = :recordId];
        total = 0;
        vat = 0;
           
        if(quotation.Quotation_Line_Items__r!=null){
            for(ETT_Quotation_Line_Item__c qli:quotation.Quotation_Line_Items__r){
                total = total + qli.ETT_Total_Price__c;
            }
            total = total;
            if(quotation.Claim_Amount__c != null){
                vat = ((total- quotation.Claim_Amount__c) * 0.05);
                totalAmount = (vat + (total- quotation.Claim_Amount__c));
            }
        }
        
        quotLines = [select id,name,Collection_Card__c,Collection_Card__r.Name,Collection_Card__r.ETT_Collection_Date__c from ETT_Quotation_Line_Item__c where ETT_Quotation__c=:recordId];
        
       set<string> collCardset = new set<string>();
       set<string> collCardDateSet = new set<string>();
       for(ETT_Quotation_Line_Item__c line: quotLines){
           if(line.Collection_Card__c != null){
               collCardset.add(line.Collection_Card__r.Name);
              
               DateTime dt = Date.valueOf(line.Collection_Card__r.ETT_Collection_Date__c);
               collCardDateSet.add(string.valueof(dt.format('dd-MM-yyyy')));
           }
            
        }
        List<String> collCardsetList = new List<String>(collCardset);
        List<String> collCardDateList = new List<String>(collCardDateSet);
       
        collCards = string.join(collCardsetList,',');
        
        collCardsDates = string.join(collCardDateList,',');
    }
        
    

}