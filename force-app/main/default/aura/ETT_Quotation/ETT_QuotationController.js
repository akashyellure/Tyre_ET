({
    doInit : function(component, event, helper) {

        var mapCollectionCard =component.get('v.mapCollectionCard');
        var options=new Set();
        var currentCollectionCard=[];
        var custLabelsFM = $A.get("$Label.c.ETT_InspectionCriteria_FM");
        var custLabelsHOO = $A.get("$Label.c.ETT_InspectionCriteria_HOO");
        var currentUser =  $A.get("$SObjectType.CurrentUser.Id");
        helper.getPriceDetails(component, event, helper);
        component.set("v.showSpinner",true);

        if(custLabelsFM==currentUser){
            component.set("v.isUserFM",custLabelsFM);
        }
        if(custLabelsHOO==currentUser){
            component.set("v.isUserHOO",custLabelsHOO);
        }
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        
        //if(custLabelsFM==currentUser || custLabelsHOO==currentUser){
        var actSave = component.get("c.getTyreDetails");
        actSave.setParams({
            collCardId:component.get("v.recordId") 
        });
        actSave.setCallback(this, function(response) {
            component.set("v.showSpinner",false);

            var state = response.getState();
            if (state === "SUCCESS") {
                
                //console.log('--lineItems--'+JSON.stringify(response.getReturnValue()));
                
                var CCList = [];
                var CCDateList = [];
                var tyreSizeList = [];
                var tyreSizeCount = [];
                var tyreSizeArr = [];
                var lstTyre = [];
                var conts = response.getReturnValue();
                var i=0,j=0,p=0;
                var totalPrice = 0;
                var count=0;
                var listOfTyresizeStatusType = [];
                
                let data = response.getReturnValue();
                try{
                    data.forEach(function(item,key){
                        
                        var addRowInList = component.get("v.lstObjects");
                        var tempObj = new Object();
                        
                        if(!CCList.includes(item.ETT_Collection_Card__r['Name'])){
                            CCList.push(item.ETT_Collection_Card__r['Name']);
                        }
                        if(!CCDateList.includes(item.ETT_Collection_Card__r['ETT_Collection_Date__c'])){
                            CCDateList.push(item.ETT_Collection_Card__r['ETT_Collection_Date__c']);
                        }
                        
                        var record=item.ETT_Collection_Card__r['Name']+'-'+item.ETT_Collection_Card__r['ETT_Collection_Date__c'];
                        options.add(record);
                        
                        
                        if(item.ETT_Collection_Card__c==component.get("v.recordId")){
                            if(currentCollectionCard.length==0)
                            currentCollectionCard.push(record);
                        }
                        
                        tempObj.Collection_Card__c = item.ETT_Collection_Card__c;
                        tempObj.ETT_Tyre_Size_Name__c = item.Tyre_Size__c;
                        tempObj.ETT_Status__c = item.ETT_Status__c;
                        tempObj.TyreInventory = item.Tyre_Inventory__c;
                        tempObj.ETT_Job_Type__c = item.Tyre_Inventory__r['Job_Type__c'];
                        tempObj.isSelected = false;
                        tempObj.Quantity = 1;
                        tempObj.Name=item.ETT_Collection_Card__r['Name'];
                        tempObj.ETT_Collection_Date__c=item.ETT_Collection_Card__r['ETT_Collection_Date__c'];

                        
                        if(item.ETT_Status__c == 'Send Back'){
                            tempObj.ETT_Unit_Price__c = '0';
                        }else if(item.Tyre_Inventory__r['Party_Type__c'] =='Customer' && item.Tyre_Inventory__r['Job_Type__c']=='Repair' ){
                            tempObj.ETT_Unit_Price__c = item.Tyre_Inventory__r['Pricing_Information__r']['ETT_Repair_Price__c'];
                        }else if(item.Tyre_Inventory__r['Party_Type__c'] =='Customer'&& item.Tyre_Inventory__r['Job_Type__c']=='Retread' ){
                            
                            if(item.Tyre_Inventory__r['Process_Type__c']=='Precure'){
                                tempObj.ETT_Unit_Price__c = item.Tyre_Inventory__r['Pricing_Information__r']['ETT_Retread_Price_P__c'];
                                
                            }else if(item.Tyre_Inventory__r['Process_Type__c']=='Hot'){
                                tempObj.ETT_Unit_Price__c = item.Tyre_Inventory__r['Pricing_Information__r']['ETT_Retread_Price_H__c'];
                            }else{
                                tempObj.ETT_Unit_Price__c ='0';
                            }
                            //tempObj.ETT_Unit_Price__c = item.Tyre_Inventory__r['Pricing_Information__r']['ETT_Purchase_Price__c']; 
                        }else if(item.Tyre_Inventory__r['Party_Type__c'] =='Supplier' && item.Tyre_Inventory__r['Job_Type__c']=='Repair' ){
                            tempObj.ETT_Unit_Price__c = item.Tyre_Inventory__r['Pricing_Information__r']['ETT_Repair_Price__c'];
                        }else if(item.Tyre_Inventory__r['Party_Type__c'] =='Supplier' && item.Tyre_Inventory__r['Job_Type__c']=='Retread' ){
                            
                            if(item.Tyre_Inventory__r['Process_Type__c']=='Precure'){
                                tempObj.ETT_Unit_Price__c = item.Tyre_Inventory__r['Pricing_Information__r']['ETT_Retread_Price_P__c'];
                                
                            }else if(item.Tyre_Inventory__r['Process_Type__c']=='Hot'){
                                tempObj.ETT_Unit_Price__c = item.Tyre_Inventory__r['Pricing_Information__r']['ETT_Retread_Price_H__c'];
                            }else{
                                tempObj.ETT_Unit_Price__c ='0';
                            }
                        }else{
                            tempObj.ETT_Unit_Price__c ='0';
                        }
                        
                        tempObj.ETT_Total__c = (tempObj.Quantity*tempObj.ETT_Unit_Price__c);
                        
                        if(item.ETT_Collection_Card__c==component.get("v.recordId")){

                        totalPrice = (totalPrice + tempObj.ETT_Total__c);
                        //console.log(tempObj)
                        addRowInList.push(tempObj);
                        }
                        component.set("v.lstObjects",addRowInList);
                        //var lst = component.get("v.lstObjects");
                        //alert('Line Item'+JSON.stringify(lst));
                        
                       var list= [];
                        if(mapCollectionCard[item.ETT_Collection_Card__r['Name']+'-'+item.ETT_Collection_Card__r['ETT_Collection_Date__c']]!=undefined){
                            var list= mapCollectionCard[item.ETT_Collection_Card__r['Name']+'-'+item.ETT_Collection_Card__r['ETT_Collection_Date__c']];
                            list.push(tempObj);
                            mapCollectionCard[item.ETT_Collection_Card__r['Name']+'-'+item.ETT_Collection_Card__r['ETT_Collection_Date__c']]=list;
                        }else{
                            list.push(tempObj)
                            mapCollectionCard[item.ETT_Collection_Card__r['Name']+'-'+item.ETT_Collection_Card__r['ETT_Collection_Date__c']]=list;
                        }
                        console.log('mapCollectionCardmapCollectionCard'+mapCollectionCard);
                    });
                }catch(e){
                    console.log(e.message)
                }
                
                component.set('v.lstCC',CCList);
                component.set('v.CCDateList',CCDateList);  
                component.set('v.mapCollectionCard',mapCollectionCard);
                component.set('v.currentCollectionCard',currentCollectionCard);
                
                var itrlist=[];
                
                    for (const item of options)	
                    itrlist.push({'label':item,'value':item});

                component.set('v.options',itrlist);  

                
                var vat = 0;
                var totalAmount = 0;
                
                if(totalPrice!=0){
                    vat = (totalPrice * 0.05);                    
                    component.set('v.vat',vat);      
                    totalAmount = totalPrice + vat;
                    component.set('v.totalAmount',totalAmount);
                }
                component.set('v.totalPrice',totalPrice);
                /*  for(var i=0;i<lstTyre.length;i++){
                    
                    for(var key in conts){
                        var tyreSizeName = conts[key]['ETT_Tyre_Size_Name__c']; 
                        if(lstTyre[i].Name==tyreSizeName){
                            lstTyre[i].count = ++lstTyre[i].count;
                        }
                    }
                }
                console.log('--lstTyre--'+JSON.stringify(lstTyre));
					
                
                for(var key in conts){
                    var addRowInList = component.get("v.lstObjects");
                    var contactObj = new Object();
                   
                    for(var k in conts[key]){
                       
                        var ccName = conts[key]['ETT_Collection_Card__r']['Name'];
                        if(!CCList.includes(ccName)){
                            CCList[i] = conts[key]['ETT_Collection_Card__r']['Name'];
                            i++;
                        }
                        var ccDate = conts[key]['ETT_Collection_Card__r']['ETT_Collection_Date__c'];
                        console.log(ccDate);
                        if(!CCDateList.includes(ccDate)){
                            CCDateList[p] = conts[key]['ETT_Collection_Card__r']['ETT_Collection_Date__c'];
                            p++;
                        }
                        
                        var tyreSizeName = conts[key]['ETT_Tyre_Size_Name__c']; 
                        if(!tyreSizeList.includes(tyreSizeName)){
                            tyreSizeList[j] = tyreSizeName; 
                            j++;
                        }
                        
                        contactObj.ETT_Tyre_Size_Name__c = conts[key]['ETT_Tyre_Size_Name__c'];
                        contactObj.ETT_Tyre_Size__c = conts[key]['ETT_Tyre_Size__c'];
                        
                        if("Inspection_Cards__r" in conts[key]){
                            contactObj.ETT_Status__c = conts[key]['Inspection_Cards__r'][0]['ETT_Status__c'];    
                        }
                        if(k=='ETT_Job_Type__c'){
                            contactObj.ETT_Job_Type__c = conts[key][k];
                        }
                    }
                    contactObj.Collection_Card__c =conts[key]['ETT_Collection_Card__c'];
                    contactObj.ETT_Work_Order_Line_Item__c=conts[key]['Id'];
                    
					contactObj.isSelected = false;
                    contactObj.ETT_Quantity__c = 1;
                    let tyreSizeVsPrice = component.get("v.tyreSizeVsPrice");
                    if( conts[key]['Inspection_Cards__r'][0]['ETT_Status__c'] == 'Send Back'){
                        contactObj.ETT_Unit_Price__c = '0';
                    }else{
                        contactObj.ETT_Unit_Price__c =  tyreSizeVsPrice.get(tyreSizeName);  
                    }
                   
                    
                    contactObj.ETT_Total__c = (contactObj.ETT_Quantity__c*contactObj.ETT_Unit_Price__c);
                    totalPrice = (totalPrice + contactObj.ETT_Total__c);
                    addRowInList.push(contactObj);
                    component.set("v.lstObjects",addRowInList);
                }*/
                /*  for(var key in conts){
                    var addRowInList = component.get("v.lstObjects");
                    var contactObj = new Object();
                   
                    for(var k in conts[key]){
                        
                        var ccName = conts[key]['ETT_Collection_Card__r']['Name'];
                        if(!CCList.includes(ccName)){
                            CCList[i] = conts[key]['ETT_Collection_Card__r']['Name'];
                            i++;
                        }
                        var ccDate = conts[key]['ETT_Collection_Card__r']['ETT_Collection_Date__c'];
                        console.log(ccDate);
                        if(!CCDateList.includes(ccDate)){
                            CCDateList[p] = conts[key]['ETT_Collection_Card__r']['ETT_Collection_Date__c'];
                            p++;
                        }
                        
                        var tyreSizeName = conts[key]['Tyre_Size__c']; 
                        if(!tyreSizeList.includes(tyreSizeName)){
                            tyreSizeList[j] = tyreSizeName; 
                            j++;
                        }
                       contactObj.Collection_Card__c =conts[key]['ETT_Collection_Card__c'];
                        
                        contactObj.ETT_Work_Order_Line_Item__c=conts[key]['Id'];
                        contactObj.ETT_Tyre_Size_Name__c = conts[key]['Tyre_Size__c'];
                        contactObj.ETT_Tyre_Size__c = conts[key]['Tyre_Inventory__r']['ETT_Tyre_Size_Master__c'];
                        
                       
                        contactObj.ETT_Status__c = conts[key]['ETT_Status__c'];    
                        contactObj.TyreInventory = conts[key]['Tyre_Inventory__c'];
                        
                        if("Tyre_Inventory__r" in conts[key]){
                            contactObj.ETT_Job_Type__c = conts[key]['Tyre_Inventory__r']['Job_Type__c'];
                        }
                        
                        
                    }
				    contactObj.isSelected = false;
                    contactObj.Quantity = 1;
                   
                    let tyreSizeVsPrice = component.get("v.tyreSizeVsPrice");
                    if(conts[key]['ETT_Status__c'] == 'Send Back'){
                        contactObj.ETT_Unit_Price__c = '0';
                    }else{
                        contactObj.ETT_Unit_Price__c =  tyreSizeVsPrice.get(tyreSizeName);  
                    }
                    
                   contactObj.ETT_Total__c = (contactObj.Quantity*contactObj.ETT_Unit_Price__c);
                   totalPrice = (totalPrice + contactObj.ETT_Total__c);
                    addRowInList.push(contactObj);
                   component.set("v.lstObjects",addRowInList);
                }                
               
                component.set('v.lstCC',CCList);
                component.set('v.CCDateList',CCDateList);                
                
                
                var vat = 0;
                var totalAmount = 0;
                
                if(totalPrice!=0){
                    vat = (totalPrice * 0.05);                    
                    component.set('v.vat',vat);      
                    totalAmount = totalPrice + vat;
                    component.set('v.totalAmount',totalAmount);
                }
                component.set('v.totalPrice',totalPrice);*/
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        
                        helper.showErrorToast({
                            title: "Error: ",
                            type: "error",
                            message:errors[0].message
                        });
                        
                    }
                }
            }else if (state === "INCOMPLETE") {
                
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:'No response from server or client is offline.'
                });                
                console.log('No response from server or client is offline.');
            }else {
                console.log("Failed with state: " + state);
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:state
                });
            }
        });
        $A.enqueueAction(actSave);
        //}
        
        
        
        var action = component.get("c.getTrafficFine");
        action.setParams({
            accountId:component.get("v.recordId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state: '+state);
            
            if (state === "SUCCESS") {
                //console.log('getTrafficFine : '+JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                component.set('v.lstWallet',result);
                //console.log('wallet: '+JSON.stringify(result));
                //console.log('wallet size: '+result.length);
                if(result.length>0){
                    component.set('v.isWalletEmpty',true);  
                }else{
                    component.set('v.isWalletEmpty',false);
                }
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message);
                        
                        helper.showErrorToast({
                            title: "Error: ",
                            type: "error",
                            message:errors[0].message
                        });
                        
                    }
                }
            }else if (state === "INCOMPLETE") {
                
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:'No response from server or client is offline.'
                });                
                console.log('No response from server or client is offline.');
            }else {
                console.log("Failed with state: " + state);
                helper.showErrorToast({
                    title: "Error: ",
                    type: "error",
                    message:state
                });
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    handleSingleQuotation : function(component, event, helper){
        var lstObjects = component.get("v.lstObjects");
        var totalPrice = 0;
        var vat = 0;
        var totalAmount = 0;
        for(var i=0;i<lstObjects.length;i++){
            if(lstObjects[i].isSelected){
                totalPrice = (totalPrice + lstObjects[i].ETT_Total__c);
                console.log(totalPrice);
            }           
        }
        if(totalPrice!=0){
            vat = (totalPrice * 0.05);                    
            component.set('v.vat',vat);      
            totalAmount = totalPrice + vat;
            component.set('v.totalAmount',totalAmount);
        }
        
        component.set('v.totalPrice',totalPrice);
        
        
    },
    
    handleSelectAllQuotation : function(component, event, helper){
        
        var totalPrice = 0;
        var vat = 0;
        var totalAmount = 0;
        
        var isSelectAll = component.get("v.isSelectAll");
        var lstObjects = component.get("v.lstObjects");
        
        console.log(JSON.stringify(lstObjects));
        
        for(var i=0;i<lstObjects.length;i++){
            if(isSelectAll){
                lstObjects[i].isSelected = true;   
                totalPrice = (totalPrice + lstObjects[i].ETT_Total__c);
            }else{
                lstObjects[i].isSelected = false;                
            }            
        }
        component.set("v.lstObjects",lstObjects);
        
        if(totalPrice!=0){
            vat = (totalPrice * 0.05);                    
            component.set('v.vat',vat);      
            totalAmount = totalPrice + vat;
            component.set('v.totalAmount',totalAmount);
        }
        
        component.set('v.totalPrice',totalPrice);
        
        
        
    },
    
    
    handleSelectAllClaimTyreSettlement : function(component, event, helper){
        
        var isSelectAllClaim = component.get("v.isSelectAllClaim");
        var lstWallet = component.get("v.lstWallet");
        console.log(JSON.stringify(lstWallet));
        
        for(var i=0;i<lstWallet.length;i++){
            if(isSelectAllClaim){
                lstWallet[i].ETT_Is_Checked__c = true;                
            }else{
                lstWallet[i].ETT_Is_Checked__c = false;                
            }            
        }
        component.set("v.lstWallet",lstWallet);
        
    },
    handleCollectionCardChange : function(component, event, helper){
        debugger;
        var totalPrice = 0;
        
        var lstvalues = component.get("v.currentCollectionCard");
        var mapCollectionCard = component.get("v.mapCollectionCard");
        var listTable=[];
        for(var l in lstvalues){
          listTable.push(...mapCollectionCard[lstvalues[l]]);
        }
        
       for(var l in listTable)
        totalPrice = (totalPrice + listTable[l].ETT_Total__c);

        
        component.set("v.totalPrice",totalPrice);
        component.set("v.lstObjects",listTable);
        
    },
    submit : function(component, event, helper){
        var lstObj = component.get("v.lstObjects");
        //alert('Line Item'+JSON.stringify(lstObj));
        if(lstObj!=null && lstObj.length>0){
            
            var addRowInList = component.get("v.lstQuotation");
            for(var i=0;i<lstObj.length;i++){
                if(lstObj[i].isSelected){                    
                    
                    var quotLineObj = new Object();
                    quotLineObj.sobjectType = 'ETT_Quotation_Line_Item__c';
                    quotLineObj.ETT_Tyre_Inventory__c = lstObj[i].TyreInventory;
                    // quotLineObj.ETT_Tyre_Size_Master__c = lstObj[i].ETT_Tyre_Size_Master__c;
                    quotLineObj.ETT_Status__c = lstObj[i].ETT_Status__c;
                    quotLineObj.ETT_Job_Type__c = lstObj[i].ETT_Job_Type__c;
                    quotLineObj.ETT_Quantity__c = lstObj[i].Quantity;
                    quotLineObj.ETT_Unit_Price__c = lstObj[i].ETT_Unit_Price__c;
                    
                    quotLineObj.ETT_Total__c = lstObj[i].ETT_Total__c;
                    quotLineObj.ETT_Account__c = component.get("v.accID");
                    quotLineObj.Collection_Card__c =lstObj[i].Collection_Card__c;
                    quotLineObj.Tyre_Size_New__c = lstObj[i].ETT_Tyre_Size_Name__c;
                    //quotLineObj.Unit_Price_New__c = lstObj[i].ETT_Unit_Price__c;
                    
                    addRowInList.push(quotLineObj);
                }
            }
            component.set("v.lstQuotation",addRowInList);
            if(addRowInList.length > 0){
                
                var actSave = component.get("c.createQuotations");
                actSave.setParams({
                    lstQuotation:component.get("v.lstQuotation"),
                    accountId:component.get("v.accID"),   //component.get("v.recordId")
                    Email:component.get("v.contactEmail"),
                    KindAtten:component.get("v.contactName"),
                    claimAmount:component.get("v.claimAmount"),
                    selectedWallet:component.get("v.selectedLstWallet")
                });
                component.set("v.showSpinner",true);
                actSave.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        //console.log(JSON.stringify(response.getReturnValue()));
                        component.set("v.showSpinner",false);
                        helper.showErrorToast({
                            title: "Success: ",
                            type: "success",
                            message: "Quotations has been created successfully"
                        });
                        $A.get('e.force:refreshView').fire();
                        $A.get("e.force:closeQuickAction").fire();
                        
                    }else if(state === "ERROR"){
                        var errors = action.getError();
                        if (errors) {
                            component.set("v.showSpinner",false);
                            if (errors[0] && errors[0].message) {
                                console.log(errors[0].message);
                                
                                helper.showErrorToast({
                                    title: "Error: ",
                                    type: "error",
                                    message:errors[0].message
                                });
                                
                            }
                        }
                    }else if (state === "INCOMPLETE") {
                        component.set("v.showSpinner",false);
                        helper.showErrorToast({
                            title: "Error: ",
                            type: "error",
                            message:'No response from server or client is offline.'
                        });                
                        console.log('No response from server or client is offline.');
                    }else {
                        console.log("Failed with state: " + state);
                        helper.showErrorToast({
                            title: "Error: ",
                            type: "error",
                            message:state
                        });
                    }
                });
                $A.enqueueAction(actSave); 
            }else{
                helper.showErrorToast({
                    title: "Warning",
                    type: "Warning",
                    message:'Please select at least one record'
                });
            }
        }
        
        //console.log(JSON.stringify(component.get("v.lstQuotation")));
        
        
        
        
    },
    
    
    claimSettlement : function(component, event, helper){
        //Modified By Janardhan        
        var lstWallet = component.get("v.lstWallet");
        let selectedLstWallet = component.get("v.selectedLstWallet");
        
        var claimAmount = 0;
        for(var i=0;i<lstWallet.length;i++){
            if(lstWallet[i].ETT_Is_Checked__c){
                claimAmount = claimAmount + lstWallet[i].Adjustment__c;  
                
                var walletObj = new Object();
                walletObj.sobjectType = 'ET_Tyre_Wallet__c';
                walletObj.Id = lstWallet[i].Id;
                walletObj.Status__c='Paid';
                
                selectedLstWallet.push(walletObj);                    
                
            }           
        }
        component.set("v.selectedLstWallet",selectedLstWallet);
        console.log('claimAmount: '+claimAmount);
        component.set('v.claimAmount',claimAmount);
        
        var totalPrice = component.get('v.totalPrice');
        totalPrice = totalPrice - claimAmount;
        
        var vat = (totalPrice * 0.05);                    
        component.set('v.vat',vat);      
        var totalAmount = totalPrice + vat;
        component.set('v.totalAmount',totalAmount);
        
        component.set('v.disablBtn',true);              
    },
    
    //Created By Janardhan
    onCollectionCardLoad : function(component, event, helper) {
        
        let data = component.get("v.CollectionCardRecord");
        try{
            if(data){
                component.set("v.accID",data.ETT_Accounts__c);
                var action = component.get('c.getContactsFromAccountID');
                action.setParams({
                    accId:data.ETT_Accounts__c
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (state === "SUCCESS") {  
                        let data = response.getReturnValue();
                        if(data){
                            component.set("v.contactName",data[0].Name);
                            component.set("v.contactEmail",data[0].Email);
                        }
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                                
                            }
                        } else {
                            console.log("Unknown error");
                            
                        }
                    }
                }); 
                
                $A.enqueueAction(action); 
                
            }
        }catch(err){
            console.log(err.message);
        }
    },
    
    cancel : function(component, event, helper){
        
        $A.get("e.force:closeQuickAction").fire();
    }
    
    
})