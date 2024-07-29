({
    doInit: function(component, event, helper) {
        
        helper.setBeadAreaPickListValue1(component);
        helper.setValueForSidewallArea(component);
        helper.setValueForCrownArea(component);
        helper.setValueForTyreInterior(component);
        helper.setValueForAnyArea(component);
        helper.setValueForHolesandInjuries(component);
        
        helper.setValueForHolesandInjuries(component);
        helper.setValueForMissingLooseTread(component);
        helper.setValueForCracks(component);
        helper.setValueForBulgesDepressions(component);
        helper.setValueForMiscellaneous(component);
        var tyreLife = component.get('v.tyreLife');
        if(tyreLife=='1'){
            console.log('if tyreLife: '+tyreLife);
            component.set('v.selectedValue', '1');
            component.set('v.tyerLifeHeadingName', 'A. Bead Area');
            component.set('v.title', 'New tyre and casing Inspection Procedures');
            component.set('v.stepNo', '1');        
       }else{
            console.log('else tyreLife: '+tyreLife);
            component.set('v.SubStepNo', '1');       
            component.set('v.stepNo', '2');
            component.set('v.title', 'Retreaded Tyre Inspection Procedures');
            component.set('v.selectedValue', '2');        
       }
       // alert(component.get('v.tyreLife'))
        var action = component.get("c.getInspectionCardDetails");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                
                for(var i=0;i<result.length;i++){
                    
                    for(var j=0;j<result[i]['Tyre_Rejection_Sub_Line_Items__r'].length;j++){
                        if(result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['ETT_Status__c']=='Rejected'){
                            if(tyreLife=='1'){
                                if(result[i].Name=='BeadArea'){
                                    console.log(result[i].ETT_Good_Condition__c);
                                    var beadArea = component.get('v.allBeadAreaOptions.BeadArea');    
                                    if(beadArea!=null && beadArea.length>0){
                                        for(var k=0;k<beadArea.length;k++){
                                            if(beadArea[k].label==result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['Name']){
                                                beadArea[k].value='Rejected';
                                            }
                                            
                                        }
                                        component.set('v.allBeadAreaOptions.BeadArea',beadArea);
                                    }
                                    component.set('v.allBeadAreaOptions.selectedStatus',result[i].ETT_Good_Condition__c);
                                }
                                if(result[i].Name=='SideWallArea'){
                                    var SidewallArea = component.get('v.allSidewallAreaOptions.SidewallArea');    
                                    if(SidewallArea!=null && SidewallArea.length>0){
                                        for(var k=0;k<SidewallArea.length;k++){
                                            if(SidewallArea[k].label==result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['Name']){
                                                SidewallArea[k].value='Rejected';
                                            }   
                                        }
                                        component.set('v.allSidewallAreaOptions.SidewallArea',SidewallArea);
                                    }
                                    component.set('v.allSidewallAreaOptions.selectedStatus',result[i].ETT_Good_Condition__c);
                                }
                                if(result[i].Name=='CrownArea'){
                                    var CrownArea = component.get('v.allCrownAreaOptions.CrownArea');    
                                    if(CrownArea!=null && CrownArea.length>0){
                                        for(var k=0;k<CrownArea.length;k++){
                                            if(CrownArea[k].label==result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['Name']){
                                                CrownArea[k].value='Rejected';
                                            }   
                                        }
                                        component.set('v.allCrownAreaOptions.CrownArea',CrownArea);
                                    }
                                    component.set('v.allCrownAreaOptions.selectedStatus',result[i].ETT_Good_Condition__c);
                                }
                                if(result[i].Name=='TyreInterior'){
                                    var TyreInterior = component.get('v.allTyreInteriorOptions.TyreInterior');    
                                    if(TyreInterior!=null && TyreInterior.length>0){
                                        for(var k=0;k<TyreInterior.length;k++){
                                            if(TyreInterior[k].label==result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['Name']){
                                                TyreInterior[k].value='Rejected';
                                            }   
                                        }
                                        component.set('v.allTyreInteriorOptions.TyreInterior',TyreInterior);
                                    }
                                    console.log(JSON.stringify(result[i]));
                                    component.set('v.allTyreInteriorOptions.selectedStatus',result[i].ETT_Good_Condition__c);
                                }
                                if(result[i].Name=='AnyArea'){
                                    var AnyArea = component.get('v.allAnyAreaOptions.AnyArea');    
                                    if(AnyArea!=null && AnyArea.length>0){
                                        for(var k=0;k<AnyArea.length;k++){
                                            if(AnyArea[k].label==result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['Name']){
                                                AnyArea[k].value='Rejected';
                                            }   
                                        }
                                        component.set('v.allAnyAreaOptions.AnyArea',AnyArea);
                                    }
                                    component.set('v.allAnyAreaOptions.selectedStatus',result[i].ETT_Good_Condition__c);
                                }
                            }else{
                                if(result[i].Name=='HolesandInjuries'){
                                    var HolesandInjuries = component.get('v.allHolesandInjuriesOptions.HolesandInjuries');    
                                    if(HolesandInjuries!=null && HolesandInjuries.length>0){
                                        for(var k=0;k<HolesandInjuries.length;k++){
                                            if(HolesandInjuries[k].label==result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['Name']){
                                                HolesandInjuries[k].value='Rejected';
                                            }
                                            
                                        }
                                        component.set('v.allHolesandInjuriesOptions.HolesandInjuries',HolesandInjuries);
                                    }
                                    component.set('v.allHolesandInjuriesOptions.selectedStatus',result[i].ETT_Good_Condition__c);
                                }
                                if(result[i].Name=='MissingLooseTread'){
                                    var MissingLooseTread = component.get('v.allMissingLooseTreadOptions.MissingLooseTread');    
                                    if(MissingLooseTread!=null && MissingLooseTread.length>0){
                                        for(var k=0;k<MissingLooseTread.length;k++){
                                            if(MissingLooseTread[k].label==result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['Name']){
                                                MissingLooseTread[k].value='Rejected';
                                            }
                                            
                                        }
                                        component.set('v.allMissingLooseTreadOptions.MissingLooseTread',MissingLooseTread);
                                    }
                                    component.set('v.allMissingLooseTreadOptions.selectedStatus',result[i].ETT_Good_Condition__c);
                                }
                                if(result[i].Name=='Cracks'){
                                    var Cracks = component.get('v.allCracksOptions.Cracks');    
                                    if(Cracks!=null && Cracks.length>0){
                                        for(var k=0;k<Cracks.length;k++){
                                            if(Cracks[k].label==result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['Name']){
                                                Cracks[k].value='Rejected';
                                            }
                                            
                                        }
                                        component.set('v.allCracksOptions.Cracks',Cracks);
                                    }
                                    component.set('v.allCracksOptions.selectedStatus',result[i].ETT_Good_Condition__c);
                                }
                                if(result[i].Name=='BulgesDepressions'){
                                    var BulgesDepressions = component.get('v.allBulgesDepressionsOptions.BulgesDepressions');    
                                    if(BulgesDepressions!=null && BulgesDepressions.length>0){
                                        for(var k=0;k<BulgesDepressions.length;k++){
                                            if(BulgesDepressions[k].label==result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['Name']){
                                                BulgesDepressions[k].value='Rejected';
                                            }
                                            
                                        }
                                        component.set('v.allBulgesDepressionsOptions.BulgesDepressions',BulgesDepressions);
                                    }
                                    component.set('v.allBulgesDepressionsOptions.selectedStatus',result[i].ETT_Good_Condition__c);
                                }
                                if(result[i].Name=='Miscellaneous'){
                                    var Miscellaneous = component.get('v.allMiscellaneousOptions.Miscellaneous');    
                                    if(Miscellaneous!=null && Miscellaneous.length>0){
                                        for(var k=0;k<Miscellaneous.length;k++){
                                            if(Miscellaneous[k].label==result[i]['Tyre_Rejection_Sub_Line_Items__r'][j]['Name']){
                                                Miscellaneous[k].value='Rejected';
                                            }
                                            
                                        }
                                        component.set('v.allMiscellaneousOptions.Miscellaneous',Miscellaneous);
                                    }
                                    component.set('v.allMiscellaneousOptions.selectedStatus',result[i].ETT_Good_Condition__c);
                                }
                            }
                            
                        }
                        
                    }
                }
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);

      
    },
    
    
    
    
    SubmitTyreLifeOne: function(component, event, helper){
        
        /*if(component.get('v.allAnyAreaOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for All Any Area Options"
            });
            return false;
        }*/
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allAnyAreaOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.AnyArea.length;i++){
            var FileWrapper = [];  
            Other = mainFocusObj.AnyArea[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }
            for(var j=0;j<mainFocusObj.AnyArea[i].inputFields.length;j++){
                if(mainFocusObj.AnyArea[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.AnyArea[i].inputFields[j].value;
                }
                if(mainFocusObj.AnyArea[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.AnyArea[i].inputFields[j].value;
                }
                if(mainFocusObj.AnyArea[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.AnyArea[i].inputFields[j].value;
                }
                if(mainFocusObj.AnyArea[i].inputFields[j].label.includes('strFileName')){
                    if(component.get('v.allAnyAreaOptions.selectedStatus')=='No'){
                        if(mainFocusObj.AnyArea[i].inputFields[j].value==''){
                            /*helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            
                        }
                    }
                    strFileName = mainFocusObj.AnyArea[i].inputFields[j].value;
                }
                if(mainFocusObj.AnyArea[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.AnyArea[i].inputFields[j].value;
                }
                if(mainFocusObj.AnyArea[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.AnyArea[i].inputFields[j].value;
                }
                if(mainFocusObj.AnyArea[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.AnyArea[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            
            if(TyreRejectionLineItem[i].tyreRejectionName == 'AnyArea'){
                TyreRejectionLineItem[i].strRecordTypeName = 'New Tyre and Casing Inspection Procedures';                
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        
        var tyreInspectionDetails = new Object();
        tyreInspectionDetails.Id = component.get("v.recordId");
        tyreInspectionDetails.RecordTypeId = component.get("v.TyreInspectionRecord.RecordTypeId");        
        tyreInspectionDetails.ETT_Brand__c = component.get("v.TyreInspectionRecord.ETT_Brand__c");        
        tyreInspectionDetails.ETT_Pattern__c = component.get("v.TyreInspectionRecord.ETT_Pattern__c");        
        tyreInspectionDetails.ETT_Tyre_Size__c = component.get("v.TyreInspectionRecord.ETT_Tyre_Size__c");        
        tyreInspectionDetails.ETT_Country__c = component.get("v.TyreInspectionRecord.ETT_Country__c");        
        tyreInspectionDetails.ETT_Account__c = component.get("v.TyreInspectionRecord.ETT_Account__c");        
        
        var isRejected;
        isRejected = false;
        var TyreRejectionLineItemArr = component.get("v.TyreRejectionLineItem");
        for(var i=0;i<TyreRejectionLineItemArr.length;i++){
            for(var j=0;j<TyreRejectionLineItemArr[i].lstTyreRejectionSubLineItems.length;j++){
                if(TyreRejectionLineItemArr[i].lstTyreRejectionSubLineItems[j].strStatus == 'Rejected'){
                    tyreInspectionDetails.ETT_Status__c = 'Send Back';
                    isRejected = true;
                }
            }
            if(isRejected==false){
                TyreRejectionLineItemArr[i].goodCondition = 'Yes';
                //delete TyreRejectionLineItemArr[i];
            }else{
                TyreRejectionLineItemArr[i].goodCondition = 'No';                    
            }
        }
        if(isRejected==false){
            tyreInspectionDetails.ETT_Status__c = 'Accept';
        }        

        //InspectionTechincalSkill
        var InspectionTechincalSkill = new Object();//component.get("v.InspectionTechincalSkill"); 
        
        InspectionTechincalSkill.isWearRequiredPPT= true;
        InspectionTechincalSkill.isSuportingToolsavilable = true;
        InspectionTechincalSkill.isEletornicProbinWorkingCondition= true,
        InspectionTechincalSkill.isTyreSprederisWorkingCondtion= true,
        InspectionTechincalSkill.isSpreadLightCondtion= true;
        InspectionTechincalSkill.isTyreLiftinWorkingCondition= true;
        InspectionTechincalSkill.lstTyreRejectionLineItems = component.get("v.TyreRejectionLineItem");   
        
        var strInspectionSkillJson = JSON.stringify(InspectionTechincalSkill);
        var strInspectionJson = JSON.stringify(tyreInspectionDetails);
        
        component.set("v.submitLifeOne",true);
        
        console.log(strInspectionSkillJson);
        //return false;
        
        var action = component.get("c.tyreInsectionCardProcess");
        action.setParams({
            strInspectionJson: strInspectionJson,
            strInspectionSkillJson:strInspectionSkillJson,
            partyType: 'Supplier'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + response.getReturnValue()
                });
                urlEvent.fire();
                
                
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
            }else if (status === "INCOMPLETE") {
                
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
    SubmitMoreThanOneTyreLife: function(component, event, helper){
        /*if(component.get('v.allMiscellaneousOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for All Miscellaneous Options"
            });
            return false;
        }*/
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allMiscellaneousOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.Miscellaneous.length;i++){
            var FileWrapper = [];  
            Other = mainFocusObj.Miscellaneous[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }
            for(var j=0;j<mainFocusObj.Miscellaneous[i].inputFields.length;j++){
                if(mainFocusObj.Miscellaneous[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.Miscellaneous[i].inputFields[j].value;
                }
                if(mainFocusObj.Miscellaneous[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.Miscellaneous[i].inputFields[j].value;
                }
                if(mainFocusObj.Miscellaneous[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.Miscellaneous[i].inputFields[j].value;
                }
                if(mainFocusObj.Miscellaneous[i].inputFields[j].label.includes('strFileName')){
                    if(component.get('v.allMiscellaneousOptions.selectedStatus')=='No'){
                        if(mainFocusObj.Miscellaneous[i].inputFields[j].value==''){
                            /*helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            strFileName = mainFocusObj.Miscellaneous[i].inputFields[j].value;
                        }
                    }
                    
                }
                if(mainFocusObj.Miscellaneous[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.Miscellaneous[i].inputFields[j].value;
                }
                if(mainFocusObj.Miscellaneous[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.Miscellaneous[i].inputFields[j].value;
                }
                if(mainFocusObj.Miscellaneous[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.Miscellaneous[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'Miscellaneous'){
                TyreRejectionLineItem[i].strRecordTypeName = 'Retread Tyre Inspection Procedures';
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        var InspectionTechincalSkill = new Object();//component.get("v.InspectionTechincalSkill"); 
        
        InspectionTechincalSkill.isWearRequiredPPT= true;
        InspectionTechincalSkill.isSuportingToolsavilable = true;
        InspectionTechincalSkill.isEletornicProbinWorkingCondition= true,
        InspectionTechincalSkill.isTyreSprederisWorkingCondtion= true,
        InspectionTechincalSkill.isSpreadLightCondtion= true;
        InspectionTechincalSkill.isTyreLiftinWorkingCondition= true;
        InspectionTechincalSkill.lstTyreRejectionLineItems = component.get("v.TyreRejectionLineItem");   
        
        var tyreInspectionDetails = new Object();
        tyreInspectionDetails.Id = component.get("v.recordId");
        tyreInspectionDetails.RecordTypeId = component.get("v.TyreInspectionRecord.RecordTypeId");        
        tyreInspectionDetails.ETT_Brand__c = component.get("v.TyreInspectionRecord.ETT_Brand__c");        
        tyreInspectionDetails.ETT_Pattern__c = component.get("v.TyreInspectionRecord.ETT_Pattern__c");        
        tyreInspectionDetails.ETT_Tyre_Size__c = component.get("v.TyreInspectionRecord.ETT_Tyre_Size__c");        
        tyreInspectionDetails.ETT_Country__c = component.get("v.TyreInspectionRecord.ETT_Country__c");        
        tyreInspectionDetails.ETT_Account__c = component.get("v.TyreInspectionRecord.ETT_Account__c");        

        
        var isRejected;
        isRejected = false;
        
        var TyreRejectionLineItemArr = component.get("v.TyreRejectionLineItem");
        
        for(var i=0;i<TyreRejectionLineItemArr.length;i++){
            for(var j=0;j<TyreRejectionLineItemArr[i].lstTyreRejectionSubLineItems.length;j++){
                if(TyreRejectionLineItemArr[i].lstTyreRejectionSubLineItems[j].strStatus == 'Rejected'){
                    tyreInspectionDetails.ETT_Status__c = 'Send Back';
                    isRejected = true;
                }
            }
        }
        
        if(isRejected==false){
            tyreInspectionDetails.ETT_Status__c = 'Accept';
        }        
        component.set("v.submitLifemultiple",true);        
        var strInspectionSkillJson = JSON.stringify(InspectionTechincalSkill);
        var strInspectionJson = JSON.stringify(tyreInspectionDetails);
        
        var action = component.get("c.tyreInsectionCardProcess");
        action.setParams({
            strInspectionJson: strInspectionJson,
            strInspectionSkillJson:strInspectionSkillJson,
            partyType: 'Supplier'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + response.getReturnValue()
                });
                urlEvent.fire();
                
                
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
            }else if (status === "INCOMPLETE") {
                
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
    
    
    callBeadArea: function(component, event, helper) {
        
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allSidewallAreaOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.SidewallArea.length;i++){
            var FileWrapper = [];  
            Other = mainFocusObj.SidewallArea[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }else{
               status = 'Accepted'; 
            }
            for(var j=0;j<mainFocusObj.SidewallArea[i].inputFields.length;j++){
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('strFileName')){
                    
                    /*if(mainFocusObj.SidewallArea[i].inputFields[j].value==''){
                        helper.showErrorToast({
                            title: "Required:",
                            type: "error",
                            message:
                            "Please select a file for "+RejectionName
                        });
                        return false;
                    }*/
                    strFileName = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'SideWallArea'){
                TyreRejectionLineItem[i].strRecordTypeName = 'New Tyre and Casing Inspection Procedures';
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        component.set('v.SubStepNo', '1');
        var tab1 = component.find('tyreLifeOneBeadAreaId');
        var TabOnedata = component.find('tyreLifeOneBeadAreaTabDataId');
        
        var tab2 = component.find('tyreLifeOneSidewallAreaId');
        var TabTwoData = component.find('tyreLifeOneSidewallAreaTabDataId');
        
        var tab3 = component.find('tyreLifeOneCrownAreaId');
        var TabThreeData = component.find('tyreLifeOneCrownAreaTabDataId');
        
        var tab4 = component.find('tyreLifeOneTyreInteriorId');
        var TabFourData = component.find('tyreLifeOneTyreInteriorTabDataId');
        
        var tab5 = component.find('tyreLifeOneAnyAreaId');
        var TabFiveData = component.find('tyreLifeOneAnyAreaTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-hide');
        $A.util.addClass(TabOnedata, 'slds-show');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');        
    },
    callSideWallArea: function(component, event, helper){
        
        console.log(JSON.stringify(component.get("v.allBeadAreaOptions")));
       
        
        /*if(component.get('v.allBeadAreaOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for Bead Area"
            });
            return false;
        }*/
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allBeadAreaOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.BeadArea.length;i++){
            
            var FileWrapper = [];  
            Other = mainFocusObj.BeadArea[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }else{
               status = 'Accepted'; 
            }
            for(var j=0;j<mainFocusObj.BeadArea[i].inputFields.length;j++){
                if(mainFocusObj.BeadArea[i].inputFields[j].label.includes('Rejection Name')){
                    console.log(mainFocusObj.BeadArea[i].inputFields[j].value);
                    RejectionName = mainFocusObj.BeadArea[i].inputFields[j].value;
                }
                if(mainFocusObj.BeadArea[i].inputFields[j].label.includes('Cause Of Rejection')){
                    console.log(mainFocusObj.BeadArea[i].inputFields[j].value);
                    CauseOfRejection = mainFocusObj.BeadArea[i].inputFields[j].value;
                }
                if(mainFocusObj.BeadArea[i].inputFields[j].label.includes('Recommendation')){
                    console.log(mainFocusObj.BeadArea[i].inputFields[j].value);
                    Recommendation = mainFocusObj.BeadArea[i].inputFields[j].value;
                }
                
                if(mainFocusObj.BeadArea[i].inputFields[j].label.includes('strFileName')){
                    
                    if(component.get('v.allBeadAreaOptions.selectedStatus')=='No' && status=='Rejected'){
                        if(mainFocusObj.BeadArea[i].inputFields[j].value==''){
                            /*helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            strFileName = mainFocusObj.BeadArea[i].inputFields[j].value;
                        }
                    }
                }
                if(mainFocusObj.BeadArea[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.BeadArea[i].inputFields[j].value;
                }
                if(mainFocusObj.BeadArea[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.BeadArea[i].inputFields[j].value;
                }
                if(mainFocusObj.BeadArea[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.BeadArea[i].inputFields[j].value;
                }
            }
            
            if(Other=='Rejected'){
                FileWrapper.push({
                    'strFileType':strFileType,
                    'strFileName':strFileName,
                    'fileSourceType':fileSourceType,
                    'fileContent':fileContent,
                    'strRejectionName':RejectionName,
                    'parentId':''
                });
            }
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
            
            console.log(JSON.stringify(TyreRejectionSubLineItem));
            
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'BeadArea'){
                TyreRejectionLineItem[i].strRecordTypeName = 'New Tyre and Casing Inspection Procedures';
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        component.set('v.SubStepNo', '2');
        var tab1 = component.find('tyreLifeOneBeadAreaId');
        var TabOnedata = component.find('tyreLifeOneBeadAreaTabDataId');
        
        var tab2 = component.find('tyreLifeOneSidewallAreaId');
        var TabTwoData = component.find('tyreLifeOneSidewallAreaTabDataId');
        
        var tab3 = component.find('tyreLifeOneCrownAreaId');
        var TabThreeData = component.find('tyreLifeOneCrownAreaTabDataId');
        
        var tab4 = component.find('tyreLifeOneTyreInteriorId');
        var TabFourData = component.find('tyreLifeOneTyreInteriorTabDataId');
        
        var tab5 = component.find('tyreLifeOneAnyAreaId');
        var TabFiveData = component.find('tyreLifeOneAnyAreaTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-hide');
        $A.util.addClass(TabTwoData, 'slds-show');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');        
        
        
        
    },
    callCrownArea: function(component, event, helper) {
        
        /*if(component.get('v.allSidewallAreaOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for Sidewall Area"
            });
            return false;
        }*/
        
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allSidewallAreaOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.SidewallArea.length;i++){
            var FileWrapper = [];  
            Other = mainFocusObj.SidewallArea[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }else{
               status = 'Accepted'; 
            }
            for(var j=0;j<mainFocusObj.SidewallArea[i].inputFields.length;j++){
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('strFileName')){
                    
                    if(component.get('v.allSidewallAreaOptions.selectedStatus')=='No' && status=='Rejected'){
                        if(mainFocusObj.SidewallArea[i].inputFields[j].value==''){
                           /* helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            strFileName = mainFocusObj.SidewallArea[i].inputFields[j].value;
                        }
                    }
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
                if(mainFocusObj.SidewallArea[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.SidewallArea[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'SideWallArea'){
                TyreRejectionLineItem[i].strRecordTypeName = 'New Tyre and Casing Inspection Procedures';
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        
        component.set('v.SubStepNo', '3');        
        var tab1 = component.find('tyreLifeOneBeadAreaId');
        var TabOnedata = component.find('tyreLifeOneBeadAreaTabDataId');
        
        var tab2 = component.find('tyreLifeOneSidewallAreaId');
        var TabTwoData = component.find('tyreLifeOneSidewallAreaTabDataId');
        
        var tab3 = component.find('tyreLifeOneCrownAreaId');
        var TabThreeData = component.find('tyreLifeOneCrownAreaTabDataId');
        
        var tab4 = component.find('tyreLifeOneTyreInteriorId');
        var TabFourData = component.find('tyreLifeOneTyreInteriorTabDataId');
        
        var tab5 = component.find('tyreLifeOneAnyAreaId');
        var TabFiveData = component.find('tyreLifeOneAnyAreaTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-hide');
        $A.util.addClass(TabThreeData, 'slds-show');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');     
        
        
    },
    callTyreInterior: function(component, event, helper){
        
        /*if(component.get('v.allCrownAreaOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for All Crown Area"
            });
            return false;
        }*/
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allCrownAreaOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.CrownArea.length;i++){
            var FileWrapper = [];  
            Other = mainFocusObj.CrownArea[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }else{
               status = 'Accepted'; 
            }
            for(var j=0;j<mainFocusObj.CrownArea[i].inputFields.length;j++){
                if(mainFocusObj.CrownArea[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.CrownArea[i].inputFields[j].value;
                }
                if(mainFocusObj.CrownArea[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.CrownArea[i].inputFields[j].value;
                }
                if(mainFocusObj.CrownArea[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.CrownArea[i].inputFields[j].value;
                }
                if(mainFocusObj.CrownArea[i].inputFields[j].label.includes('strFileName')){
                    if(component.get('v.allCrownAreaOptions.selectedStatus')=='No' && status=='Rejected'){
                        if(mainFocusObj.CrownArea[i].inputFields[j].value==''){
                            /*helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            strFileName = mainFocusObj.CrownArea[i].inputFields[j].value;    
                        }
                    }
                    
                }
                if(mainFocusObj.CrownArea[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.CrownArea[i].inputFields[j].value;
                }
                if(mainFocusObj.CrownArea[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.CrownArea[i].inputFields[j].value;
                }
                if(mainFocusObj.CrownArea[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.CrownArea[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        var selectedCutsNTCList = component.get("v.selectedCutsNTCList");
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'CrownArea'){
                TyreRejectionLineItem[i].strRecordTypeName = 'New Tyre and Casing Inspection Procedures';                
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
                for(var j=0;j<selectedCutsNTCList.length;j++){
                    if(selectedCutsNTCList[j]['label']=='Cuts (0 to 10mm)'){
                        TyreRejectionLineItem[i].cuts_0_10 = selectedCutsNTCList[j]['selectedValue'];
                    }
                    if(selectedCutsNTCList[j]['label']=='Cuts (11 to 25mm)'){
                        TyreRejectionLineItem[i].cuts_11_to_25 = selectedCutsNTCList[j]['selectedValue'];
                    }
                    if(selectedCutsNTCList[j]['label']=='Cuts (26 to 38mm)'){
                        TyreRejectionLineItem[i].cuts_26_to_38 = selectedCutsNTCList[j]['selectedValue'];
                    }
                    if(selectedCutsNTCList[j]['label']=='Cuts (39 to 50mm)'){
                        TyreRejectionLineItem[i].cuts_39_to_50 = selectedCutsNTCList[j]['selectedValue'];
                    }
                    if(selectedCutsNTCList[j]['label']=='Cuts (51mm and above)'){
                        TyreRejectionLineItem[i].cuts_51 = selectedCutsNTCList[j]['selectedValue'];
                    } 
                }

                
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        
        component.set('v.SubStepNo', '4');
        var tab1 = component.find('tyreLifeOneBeadAreaId');
        var TabOnedata = component.find('tyreLifeOneBeadAreaTabDataId');
        
        var tab2 = component.find('tyreLifeOneSidewallAreaId');
        var TabTwoData = component.find('tyreLifeOneSidewallAreaTabDataId');
        
        var tab3 = component.find('tyreLifeOneCrownAreaId');
        var TabThreeData = component.find('tyreLifeOneCrownAreaTabDataId');
        
        var tab4 = component.find('tyreLifeOneTyreInteriorId');
        var TabFourData = component.find('tyreLifeOneTyreInteriorTabDataId');
        
        var tab5 = component.find('tyreLifeOneAnyAreaId');
        var TabFiveData = component.find('tyreLifeOneAnyAreaTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-hide');
        $A.util.addClass(TabFourData, 'slds-show');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');        
        
    },
    callAnyArea: function(component, event, helper){
        
        /*if(component.get('v.allTyreInteriorOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for All Tyre Interior Options"
            });
            return false;
        }*/
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allTyreInteriorOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.TyreInterior.length;i++){
            var FileWrapper = [];  
            Other = mainFocusObj.TyreInterior[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }else{
               status = 'Accepted'; 
            }
            for(var j=0;j<mainFocusObj.TyreInterior[i].inputFields.length;j++){
                if(mainFocusObj.TyreInterior[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.TyreInterior[i].inputFields[j].value;
                }
                if(mainFocusObj.TyreInterior[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.TyreInterior[i].inputFields[j].value;
                }
                if(mainFocusObj.TyreInterior[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.TyreInterior[i].inputFields[j].value;
                }
                if(mainFocusObj.TyreInterior[i].inputFields[j].label.includes('strFileName')){
                    
                    if(component.get('v.allTyreInteriorOptions.selectedStatus')=='No' && status=='Rejected'){
                        if(mainFocusObj.TyreInterior[i].inputFields[j].value==''){
                            /*helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            strFileName = mainFocusObj.TyreInterior[i].inputFields[j].value;
                        }
                    }
                    
                }
                if(mainFocusObj.TyreInterior[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.TyreInterior[i].inputFields[j].value;
                }
                if(mainFocusObj.TyreInterior[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.TyreInterior[i].inputFields[j].value;
                }
                if(mainFocusObj.TyreInterior[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.TyreInterior[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'TyreInterior'){
                TyreRejectionLineItem[i].strRecordTypeName = 'New Tyre and Casing Inspection Procedures';                
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        component.set('v.SubStepNo', '5'); 
        var tab1 = component.find('tyreLifeOneBeadAreaId');
        var TabOnedata = component.find('tyreLifeOneBeadAreaTabDataId');
        
        var tab2 = component.find('tyreLifeOneSidewallAreaId');
        var TabTwoData = component.find('tyreLifeOneSidewallAreaTabDataId');
        
        var tab3 = component.find('tyreLifeOneCrownAreaId');
        var TabThreeData = component.find('tyreLifeOneCrownAreaTabDataId');
        
        var tab4 = component.find('tyreLifeOneTyreInteriorId');
        var TabFourData = component.find('tyreLifeOneTyreInteriorTabDataId');
        
        var tab5 = component.find('tyreLifeOneAnyAreaId');
        var TabFiveData = component.find('tyreLifeOneAnyAreaTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-hide');
        $A.util.addClass(TabFiveData, 'slds-show');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');        
        
    },    
    
    
    
    tyreLifeMoreThanOneHolesAndInjuries: function(component, event, helper) {
        
        console.log(JSON.stringify(component.get("v.allMissingLooseTreadOptions")));
        /*if(component.get('v.allMissingLooseTreadOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for All Missing Loose Tread Options"
            });
            return false;
        }*/
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allMissingLooseTreadOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.MissingLooseTread.length;i++){
            var FileWrapper = [];  
            Other = mainFocusObj.MissingLooseTread[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }else{
               status = 'Accepted'; 
            }
            for(var j=0;j<mainFocusObj.MissingLooseTread[i].inputFields.length;j++){
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('strFileName')){
                    if(component.get('v.allMissingLooseTreadOptions.selectedStatus')=='No' && status=='Rejected'){
                        if(mainFocusObj.MissingLooseTread[i].inputFields[j].value==''){
                            /*helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            strFileName = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                        }
                    }
                    
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'MissingLooseTread'){
                TyreRejectionLineItem[i].strRecordTypeName = 'Retread Tyre Inspection Procedures';                
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        component.set('v.SubStepNo', '1');
        var tab1 = component.find('tyreLifeMoreThanOneHolesAndInjuriesId');
        var TabOnedata = component.find('tyreLifeMoreThanOneHolesAndInjuriesTabDataId');
        
        var tab2 = component.find('tyreLifeMoreThanOneMissingLooseTreadId');
        var TabTwoData = component.find('tyreLifeMoreThanOneMissingLooseTreadTabDataId');
        
        var tab3 = component.find('tyreLifeMoreThanOneCracksId');
        var TabThreeData = component.find('tyreLifeMoreThanOneCracksTabDataId');
        
        var tab4 = component.find('tyreLifeMoreThanOneBulgesDepressionsId');
        var TabFourData = component.find('tyreLifeMoreThanOneBulgesDepressionsTabDataId');
        
        var tab5 = component.find('tyreLifeMoreThanOneMiscellaneousId');
        var TabFiveData = component.find('tyreLifeMoreThanOneMiscellaneousTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-hide');
        $A.util.addClass(TabOnedata, 'slds-show');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');        
        
    },
    tyreLifeMoreThanOneMissingLooseTread: function(component, event, helper) {
        alert('test')
        console.log(JSON.stringify(component.get("v.allHolesandInjuriesOptions")));
        /*if(component.get('v.allHolesandInjuriesOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for All Holes and Injuries Options"
            });
            return false;
        }*/
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allHolesandInjuriesOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.HolesandInjuries.length;i++){
            var FileWrapper = [];  
            Other = mainFocusObj.HolesandInjuries[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }else{
               status = 'Accepted'; 
            }
            for(var j=0;j<mainFocusObj.HolesandInjuries[i].inputFields.length;j++){
                if(mainFocusObj.HolesandInjuries[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.HolesandInjuries[i].inputFields[j].value;
                }
                if(mainFocusObj.HolesandInjuries[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.HolesandInjuries[i].inputFields[j].value;
                }
                if(mainFocusObj.HolesandInjuries[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.HolesandInjuries[i].inputFields[j].value;
                }
                if(mainFocusObj.HolesandInjuries[i].inputFields[j].label.includes('strFileName')){
                    if(component.get('v.allHolesandInjuriesOptions.selectedStatus')=='No' && status=='Rejected'){
                        if(mainFocusObj.HolesandInjuries[i].inputFields[j].value==''){
                            /*helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            strFileName = mainFocusObj.HolesandInjuries[i].inputFields[j].value;
                        }
                    }
                    
                }
                if(mainFocusObj.HolesandInjuries[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.HolesandInjuries[i].inputFields[j].value;
                }
                if(mainFocusObj.HolesandInjuries[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.HolesandInjuries[i].inputFields[j].value;
                }
                if(mainFocusObj.HolesandInjuries[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.HolesandInjuries[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'HolesandInjuries'){
                TyreRejectionLineItem[i].strRecordTypeName = 'Retread Tyre Inspection Procedures';                
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        
        
        component.set('v.SubStepNo', '2');
        var tab1 = component.find('tyreLifeMoreThanOneHolesAndInjuriesId');
        var TabOnedata = component.find('tyreLifeMoreThanOneHolesAndInjuriesTabDataId');
        
        var tab2 = component.find('tyreLifeMoreThanOneMissingLooseTreadId');
        var TabTwoData = component.find('tyreLifeMoreThanOneMissingLooseTreadTabDataId');
        
        var tab3 = component.find('tyreLifeMoreThanOneCracksId');
        var TabThreeData = component.find('tyreLifeMoreThanOneCracksTabDataId');
        
        var tab4 = component.find('tyreLifeMoreThanOneBulgesDepressionsId');
        var TabFourData = component.find('tyreLifeMoreThanOneBulgesDepressionsTabDataId');
        
        var tab5 = component.find('tyreLifeMoreThanOneMiscellaneousId');
        var TabFiveData = component.find('tyreLifeMoreThanOneMiscellaneousTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-hide');
        $A.util.addClass(TabTwoData, 'slds-show');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');        
        
    },
    tyreLifeMoreThanOneCracks: function(component, event, helper) {
        
        console.log(JSON.stringify(component.get("v.allMissingLooseTreadOptions")));
        /*if(component.get('v.allMissingLooseTreadOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for All Missing Loose Tread Options"
            });
            return false;
        }*/
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allMissingLooseTreadOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.MissingLooseTread.length;i++){
            var FileWrapper = [];  
            if(Other=='Rejected'){
                status = 'Rejected';
            }else{
               status = 'Accepted'; 
            }
            Other = mainFocusObj.MissingLooseTread[i].value;
            for(var j=0;j<mainFocusObj.MissingLooseTread[i].inputFields.length;j++){
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('strFileName')){
                    
                    if(component.get('v.allMissingLooseTreadOptions.selectedStatus')=='No' && status=='Rejected'){
                        if(mainFocusObj.MissingLooseTread[i].inputFields[j].value==''){
                           /* helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            strFileName = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                        }
                    }
                    
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
                if(mainFocusObj.MissingLooseTread[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.MissingLooseTread[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'MissingLooseTread'){
                TyreRejectionLineItem[i].strRecordTypeName = 'Retread Tyre Inspection Procedures';                
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        
        
        component.set('v.SubStepNo', '3');
        var tab1 = component.find('tyreLifeMoreThanOneHolesAndInjuriesId');
        var TabOnedata = component.find('tyreLifeMoreThanOneHolesAndInjuriesTabDataId');
        
        var tab2 = component.find('tyreLifeMoreThanOneMissingLooseTreadId');
        var TabTwoData = component.find('tyreLifeMoreThanOneMissingLooseTreadTabDataId');
        
        var tab3 = component.find('tyreLifeMoreThanOneCracksId');
        var TabThreeData = component.find('tyreLifeMoreThanOneCracksTabDataId');
        
        var tab4 = component.find('tyreLifeMoreThanOneBulgesDepressionsId');
        var TabFourData = component.find('tyreLifeMoreThanOneBulgesDepressionsTabDataId');
        
        var tab5 = component.find('tyreLifeMoreThanOneMiscellaneousId');
        var TabFiveData = component.find('tyreLifeMoreThanOneMiscellaneousTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-hide');
        $A.util.addClass(TabThreeData, 'slds-show');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');                
    },
    tyreLifeMoreThanOneBulgesDepressions: function(component, event, helper){
        
        console.log(JSON.stringify(component.get("v.allCracksOptions")));
        /*if(component.get('v.allCracksOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for All Cracks Options"
            });
            return false;
        }*/
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allCracksOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.Cracks.length;i++){
            var FileWrapper = [];  
            Other = mainFocusObj.Cracks[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }else{
               status = 'Accepted'; 
            }
            for(var j=0;j<mainFocusObj.Cracks[i].inputFields.length;j++){
                if(mainFocusObj.Cracks[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.Cracks[i].inputFields[j].value;
                }
                if(mainFocusObj.Cracks[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.Cracks[i].inputFields[j].value;
                }
                if(mainFocusObj.Cracks[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.Cracks[i].inputFields[j].value;
                }
                if(mainFocusObj.Cracks[i].inputFields[j].label.includes('strFileName')){
                    if(component.get('v.allCracksOptions.selectedStatus')=='No' && status=='Rejected'){
                        if(mainFocusObj.Cracks[i].inputFields[j].value==''){
                          /*  helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            strFileName = mainFocusObj.Cracks[i].inputFields[j].value;
                        }
                    }
                    
                }
                if(mainFocusObj.Cracks[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.Cracks[i].inputFields[j].value;
                }
                if(mainFocusObj.Cracks[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.Cracks[i].inputFields[j].value;
                }
                if(mainFocusObj.Cracks[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.Cracks[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'Cracks'){
                TyreRejectionLineItem[i].strRecordTypeName = 'Retread Tyre Inspection Procedures';                
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        component.set('v.SubStepNo', '4');
        var tab1 = component.find('tyreLifeMoreThanOneHolesAndInjuriesId');
        var TabOnedata = component.find('tyreLifeMoreThanOneHolesAndInjuriesTabDataId');
        
        var tab2 = component.find('tyreLifeMoreThanOneMissingLooseTreadId');
        var TabTwoData = component.find('tyreLifeMoreThanOneMissingLooseTreadTabDataId');
        
        var tab3 = component.find('tyreLifeMoreThanOneCracksId');
        var TabThreeData = component.find('tyreLifeMoreThanOneCracksTabDataId');
        
        var tab4 = component.find('tyreLifeMoreThanOneBulgesDepressionsId');
        var TabFourData = component.find('tyreLifeMoreThanOneBulgesDepressionsTabDataId');
        
        var tab5 = component.find('tyreLifeMoreThanOneMiscellaneousId');
        var TabFiveData = component.find('tyreLifeMoreThanOneMiscellaneousTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-hide');
        $A.util.addClass(TabFourData, 'slds-show');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-show');
        $A.util.addClass(TabFiveData, 'slds-hide');        
    },
    tyreLifeMoreThanOneMiscellaneous: function(component, event, helper){
        
        console.log(JSON.stringify(component.get("v.allBulgesDepressionsOptions")));
        /*if(component.get('v.allBulgesDepressionsOptions.selectedStatus')==''){
            helper.showErrorToast({
                title: "Required:",
                type: "error",
                message:
                "Please select a Good Condition for All Bulges Depressions Options"
            });
            return false;
        }*/
        var mainFocusObj ={};
        mainFocusObj = component.get('v.allBulgesDepressionsOptions');
        var RejectionName, CauseOfRejection, Recommendation, Other,status;
        var strFileName,strFileType,fileSourceType,fileContent
        var TyreRejectionSubLineItem = [];
        
        for(var i=0;i<mainFocusObj.BulgesDepressions.length;i++){
            var FileWrapper = [];  
            Other = mainFocusObj.BulgesDepressions[i].value;
            if(Other=='Rejected'){
                status = 'Rejected';
            }else{
               status = 'Accepted'; 
            }
            for(var j=0;j<mainFocusObj.BulgesDepressions[i].inputFields.length;j++){
                if(mainFocusObj.BulgesDepressions[i].inputFields[j].label.includes('Rejection Name')){
                    RejectionName = mainFocusObj.BulgesDepressions[i].inputFields[j].value;
                }
                if(mainFocusObj.BulgesDepressions[i].inputFields[j].label.includes('Cause Of Rejection')){
                    CauseOfRejection = mainFocusObj.BulgesDepressions[i].inputFields[j].value;
                }
                if(mainFocusObj.BulgesDepressions[i].inputFields[j].label.includes('Recommendation')){
                    Recommendation = mainFocusObj.BulgesDepressions[i].inputFields[j].value;
                }
                if(mainFocusObj.BulgesDepressions[i].inputFields[j].label.includes('strFileName')){
                    if(component.get('v.allBulgesDepressionsOptions.selectedStatus')=='No' && status=='Rejected'){
                        if(mainFocusObj.BulgesDepressions[i].inputFields[j].value==''){
                           /* helper.showErrorToast({
                                title: "Required:",
                                type: "error",
                                message:
                                "Please select a file for "+RejectionName
                            });
                            return false;*/
                        }else{
                            strFileName = mainFocusObj.BulgesDepressions[i].inputFields[j].value;
                        }
                    }
                    
                }
                if(mainFocusObj.BulgesDepressions[i].inputFields[j].label.includes('strFileType')){
                    strFileType = mainFocusObj.BulgesDepressions[i].inputFields[j].value;
                }
                if(mainFocusObj.BulgesDepressions[i].inputFields[j].label.includes('fileSourceType')){
                    fileSourceType = mainFocusObj.BulgesDepressions[i].inputFields[j].value;
                }
                if(mainFocusObj.BulgesDepressions[i].inputFields[j].label.includes('fileContent')){
                    fileContent = mainFocusObj.BulgesDepressions[i].inputFields[j].value;
                }
            }
            FileWrapper.push({
                'strFileType':strFileType,
                'strFileName':strFileName,
                'fileSourceType':fileSourceType,
                'fileContent':fileContent,
                'strRejectionName':RejectionName,
                'parentId':''
            });
            TyreRejectionSubLineItem.push({
                'strRejectionName':RejectionName,
                'strCauseOfRejection':CauseOfRejection,
                'strRecommendations':Recommendation,
                'strOtherComments':Other,
                'strStatus':status,
                'lstFileWrapperDetails':FileWrapper
            });
        }
        component.set("v.TyreRejectionSubLineItem",TyreRejectionSubLineItem); 
        
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for(var i=0;i<TyreRejectionLineItem.length;i++){
            if(TyreRejectionLineItem[i].tyreRejectionName == 'BulgesDepressions'){
                TyreRejectionLineItem[i].strRecordTypeName = 'Retread Tyre Inspection Procedures';
                TyreRejectionLineItem[i].lstTyreRejectionSubLineItems = TyreRejectionSubLineItem;
            }
        }
        component.set("v.TyreRejectionLineItem",TyreRejectionLineItem);
        
        
        component.set('v.SubStepNo', '5');
        var tab1 = component.find('tyreLifeMoreThanOneHolesAndInjuriesId');
        var TabOnedata = component.find('tyreLifeMoreThanOneHolesAndInjuriesTabDataId');
        
        var tab2 = component.find('tyreLifeMoreThanOneMissingLooseTreadId');
        var TabTwoData = component.find('tyreLifeMoreThanOneMissingLooseTreadTabDataId');
        
        var tab3 = component.find('tyreLifeMoreThanOneCracksId');
        var TabThreeData = component.find('tyreLifeMoreThanOneCracksTabDataId');
        
        var tab4 = component.find('tyreLifeMoreThanOneBulgesDepressionsId');
        var TabFourData = component.find('tyreLifeMoreThanOneBulgesDepressionsTabDataId');
        
        var tab5 = component.find('tyreLifeMoreThanOneMiscellaneousId');
        var TabFiveData = component.find('tyreLifeMoreThanOneMiscellaneousTabDataId');
        
        //show and Active color Tab
        $A.util.addClass(tab5, 'slds-active');
        $A.util.removeClass(TabFiveData, 'slds-hide');
        $A.util.addClass(TabFiveData, 'slds-show');
        
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');        
        
    },
    
    
    
    
    
    
    tyreLifeOne: function(component, event, helper) {
        component.set('v.selectedValue', '1');
        component.set('v.tyerLifeHeadingName', 'A. Bead Area');
        component.set('v.title', 'New tyre and casing Inspection Procedures');
        component.set('v.stepNo', '1');        
    },
    tyreLifeTwo: function(component, event, helper) {
        component.set('v.SubStepNo', '1');        
        component.set('v.stepNo', '2');
        component.set('v.title', 'Retreaded Tyre Inspection Procedures');
        component.set('v.selectedValue', '2');        
    },      
    
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        let selectedVal = event.getSource().get("v.value");
        switch(selectedVal) {
            case '1':
                component.set('v.selectedValue', selectedVal);
                component.set('v.tyerLifeHeadingName', 'A. Bead Area');
                component.set('v.title', 'New tyre and casing Inspection Procedures');
                component.set('v.stepNo', '1');
                break;
            case '2':
                component.set('v.stepNo', '2');
                component.set('v.title', 'Retreaded Tyre Inspection Procedures');
                component.set('v.selectedValue', selectedVal);
                
                break;
            case '3':
                component.set('v.stepNo', '3');
                component.set('v.title', 'Retreaded Tyre Inspection Procedures');
                component.set('v.selectedValue', selectedVal);
                
                break;
            case '4':
                component.set('v.stepNo', '4');
                component.set('v.title', 'Retreaded Tyre Inspection Procedures');
                component.set('v.selectedValue', selectedVal);
                
                break;
            case '5':
                component.set('v.stepNo', '5');
                component.set('v.title', 'Retreaded Tyre Inspection Procedures');
                component.set('v.selectedValue', selectedVal);
                
                break;
                
            case 'Yes':
                var r = confirm("Are you sure Bead Area of this Tyre is in good condition?");
                if (r == true) {
                    //component.set('v.selectedValue', selectedVal);
                } else {
                    event.getSource().set("v.value", "No");
                }
                break;
            case 'No':
                var r = confirm("Are you sure Bead Area of this Tyre is in good condition?");
                if (r == true) {
                    //component.set('v.selectedValue', selectedVal);
                } else {
                    event.getSource().set("v.value", "Yes");
                }
                break;
            default:
                component.set('v.selectedValue', '');
        }
        
        
    },
    onBeadAreaChange: function(component, event, helper) {
        // get the value of select option
        var element = event.getSource();
        var id = element.getLocalId();
        let selectedVal = element.get("v.value");
        
        console.log('selectedVal: '+selectedVal);
        console.log('id: '+id);
        
        component.set('v.beadAreaVal', selectedVal);
        console.log(selectedVal);
        switch(selectedVal) {
            case 'Yes':
                 helper.handleOnGoodConditionsChange(component, id, 'Yes');
                /*var r = confirm("Are you sure Bead Area of this Tyre is in good condition?");
                if (r == true) {
                    helper.handleOnGoodConditionsChange(component, id, 'Yes');
                } else {
                    event.getSource().set("v.value", 'No');
                    helper.handleOnGoodConditionsChange(component, id, 'No');
                }*/
                break;
            case 'No':
                event.getSource().set("v.value", 'No');
                helper.handleOnGoodConditionsChange(component, id, 'No');
                break;
            default:
                // code block
        }
        
        
    },
    
    clickNext: function(component, event, helper) {
        
        let stepNo =  component.get('v.SubStepNo');
        switch(stepNo) {
            case '1':
                
                component.set('v.SubStepNo', '2');
                break;
            case '2':
                
                component.set('v.SubStepNo', '3');
                break;
            case '3':
                
                component.set('v.SubStepNo', '4');
                break;
            case '4':
                
                component.set('v.SubStepNo', '5');
                break;
            default:
                // code block
        }
        
    },
    clickPrevious: function(component, event, helper) {
        
        try{
            let stepNo =  component.get('v.SubStepNo');
            switch(stepNo) {
                case '1':
                    
                    break;
                case '2':
                    component.set('v.SubStepNo', '1');
                    break;
                case '3':
                    component.set('v.SubStepNo', '2');
                    break;
                case '4':
                    component.set('v.SubStepNo', '3');
                    break;
                case '5':
                    component.set('v.SubStepNo', '4');
                    break;
                default:
                    // code block
            }
        }catch(err){
            alert(err.message)
        }
        
    },
    cancel: function(component, event, helper) {
        
        $A.get("e.force:closeQuickAction").fire() ;
       /* //Get the event using registerEvent name. 
        var cmpEvent = component.getEvent("sampleCmpEvent"); 
        //Set event attribute value
        cmpEvent.setParams({"isPopupClose" : true}); 
        cmpEvent.fire(); 
        */
        
    },
    handleGenreChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedCutsNTCList =  component.get("v.selectedCutsNTCList");
        var selectedValues = event.getParam("value");
        var selectedCutsNTCList1 = [];
        
        for(let index in selectedValues){
            if(selectedCutsNTCList.length == 0){
                let wrp={
                    label:selectedValues[index],
                    selectedValue: 1
                };
                selectedCutsNTCList.push(wrp);
            }
            selectedCutsNTCList.find( function( ele ) { 
                if(ele.label === selectedValues[index]){
                    let wrp={
                        label:selectedValues[index],
                        selectedValue: ele.selectedValue
                    };
                    selectedCutsNTCList1.push(wrp);
                }else if(selectedCutsNTCList.length < selectedValues.length){
                    let wrp={
                        label:selectedValues[index],
                        selectedValue: 1
                    };
                    selectedCutsNTCList1.push(wrp);
                }
            } );
            
            
            /* if (selectedCutsNTCList.some(e => e.label === selectedValues[index])) {
                 let wrp={
                     label:selectedValues[index],
                     selectedValue: e.selectedValue
                 };
               selectedCutsNTCList1.push(wrp);
             }else{
                 let wrp={
                     label:selectedValues[index],
                     selectedValue: 1
                 };
                 selectedCutsNTCList1.push(wrp);
             }*/
        }
        console.log('@@@@  ', selectedCutsNTCList1)
        //Update the Selected Values  
        component.set("v.selectedCutsNTCList", selectedCutsNTCList1);
    },
    
    handleFilesChange: function (component, event, helper) {
        
        
        var Filelist = [];
        Filelist = component.get("v.fileName");
        var files = component.get("v.fileToBeUploaded");
        var allBead = component.get('v.allBeadAreaOptions');
        var fileUploadWrapper = [];
        var contentWrapperArr = [];
        var fileSourceType = event.getSource().get("v.id");
        var areaName = event.getSource().get("v.name");
        
        console.log('areaName: '+areaName);
        
        var mainFocusObj ={};
        console.log(fileSourceType);
        
        
        if(areaName=='BeadArea'){
            mainFocusObj = component.get('v.allBeadAreaOptions');
        }else if(areaName=='SidewallArea'){
            mainFocusObj = component.get('v.allSidewallAreaOptions');
        }else if(areaName=='CrownArea'){
            mainFocusObj = component.get('v.allCrownAreaOptions');
        }else if(areaName=='TyreInterior'){
            mainFocusObj = component.get('v.allTyreInteriorOptions');
        }else if(areaName=='AnyArea'){
            mainFocusObj = component.get('v.allAnyAreaOptions');
        }else if(areaName=='HolesandInjuries'){
            mainFocusObj = component.get('v.allHolesandInjuriesOptions');
        }else if(areaName=='MissingLooseTread'){
            mainFocusObj = component.get('v.allMissingLooseTreadOptions');
        }else if(areaName=='Cracks'){
            mainFocusObj = component.get('v.allCracksOptions');
        }else if(areaName=='BulgesDepressions'){
            mainFocusObj = component.get('v.allBulgesDepressionsOptions');
        }else if(areaName=='Miscellaneous'){
            mainFocusObj = component.get('v.allMiscellaneousOptions');
        }
        
        //console.log(JSON.stringify(mainFocusObj));
        
        if(files && files.length > 0) {
            for(var i=0; i < files[0].length; i++){
                var file = files[0][i];
                var reader = new FileReader();
                reader.name = file.name;
                reader.type = file.type;
                
                console.log(file.name);
                console.log(file.type);
                
                reader.onloadend = function(e) {
                    
                   // console.log(JSON.stringify(mainFocusObj));
                    console.log('inside onload');
                    
                    //Section 1
                    if(areaName=='BeadArea'){
                        for(var j=0;j<mainFocusObj.BeadArea[fileSourceType].inputFields.length;j++){
                            
                            if(mainFocusObj.BeadArea[fileSourceType].inputFields[j].label.includes('strFileName')){
                                mainFocusObj.BeadArea[fileSourceType].inputFields[j].value = e.target.name;
                            }
                            if(mainFocusObj.BeadArea[fileSourceType].inputFields[j].label.includes('strFileType')){
                                mainFocusObj.BeadArea[fileSourceType].inputFields[j].value = e.target.type;
                            }
                            if(mainFocusObj.BeadArea[fileSourceType].inputFields[j].label.includes('fileSourceType')){
                                mainFocusObj.BeadArea[fileSourceType].inputFields[j].value = fileSourceType;
                            }
                            if(mainFocusObj.BeadArea[fileSourceType].inputFields[j].label.includes('fileContent')){
                                var base64Img = e.target.result;
                                var base64result = base64Img.split(',')[1];
                                mainFocusObj.BeadArea[fileSourceType].inputFields[j].value = base64result; //base64Img.replace("data:image/png;base64,", "");//e.target.result;
                            }                        
                            
                            component.set('v.allBeadAreaOptions',mainFocusObj);   
                        }
                    }
                    if(areaName=='SidewallArea'){
                        for(var j=0;j<mainFocusObj.SidewallArea[fileSourceType].inputFields.length;j++){
                            
                            console.log('inside side wall');
                            
                            if(mainFocusObj.SidewallArea[fileSourceType].inputFields[j].label.includes('strFileName')){
                                mainFocusObj.SidewallArea[fileSourceType].inputFields[j].value = e.target.name;
                            }
                            if(mainFocusObj.SidewallArea[fileSourceType].inputFields[j].label.includes('strFileType')){
                                mainFocusObj.SidewallArea[fileSourceType].inputFields[j].value = e.target.type;
                            }
                            if(mainFocusObj.SidewallArea[fileSourceType].inputFields[j].label.includes('fileSourceType')){
                                mainFocusObj.SidewallArea[fileSourceType].inputFields[j].value = fileSourceType;
                            }
                            if(mainFocusObj.SidewallArea[fileSourceType].inputFields[j].label.includes('fileContent')){
                                //mainFocusObj.SidewallArea[fileSourceType].inputFields[j].value = e.target.result;
                                var base64Img = e.target.result;
                                var base64result = base64Img.split(',')[1];
                                mainFocusObj.SidewallArea[fileSourceType].inputFields[j].value = base64result; //base64Img.replace("data:image/png;base64,", "");//e.target.result;
                            }                        
                            
                            component.set('v.allSidewallAreaOptions',mainFocusObj);   
                        }               
                    }
                    if(areaName=='CrownArea'){
                    for(var j=0;j<mainFocusObj.CrownArea[fileSourceType].inputFields.length;j++){
                        
                        if(mainFocusObj.CrownArea[fileSourceType].inputFields[j].label.includes('strFileName')){
                            mainFocusObj.CrownArea[fileSourceType].inputFields[j].value = e.target.name;
                        }
                        if(mainFocusObj.CrownArea[fileSourceType].inputFields[j].label.includes('strFileType')){
                            mainFocusObj.CrownArea[fileSourceType].inputFields[j].value = e.target.type;
                        }
                        if(mainFocusObj.CrownArea[fileSourceType].inputFields[j].label.includes('fileSourceType')){
                            mainFocusObj.CrownArea[fileSourceType].inputFields[j].value = fileSourceType;
                        }
                        if(mainFocusObj.CrownArea[fileSourceType].inputFields[j].label.includes('fileContent')){
                            //mainFocusObj.CrownArea[fileSourceType].inputFields[j].value = e.target.result;
                            var base64Img = e.target.result;
                            var base64result = base64Img.split(',')[1];
                            mainFocusObj.CrownArea[fileSourceType].inputFields[j].value = base64result; //base64Img.replace("data:image/png;base64,", "");//e.target.result;

                        }                        
                        
                        component.set('v.allCrownAreaOptions',mainFocusObj);   
                    }
                    }
                    if(areaName=='TyreInterior'){
                    for(var j=0;j<mainFocusObj.TyreInterior[fileSourceType].inputFields.length;j++){
                        
                        if(mainFocusObj.TyreInterior[fileSourceType].inputFields[j].label.includes('strFileName')){
                            mainFocusObj.TyreInterior[fileSourceType].inputFields[j].value = e.target.name;
                        }
                        if(mainFocusObj.TyreInterior[fileSourceType].inputFields[j].label.includes('strFileType')){
                            mainFocusObj.TyreInterior[fileSourceType].inputFields[j].value = e.target.type;
                        }
                        if(mainFocusObj.TyreInterior[fileSourceType].inputFields[j].label.includes('fileSourceType')){
                            mainFocusObj.TyreInterior[fileSourceType].inputFields[j].value = fileSourceType;
                        }
                        if(mainFocusObj.TyreInterior[fileSourceType].inputFields[j].label.includes('fileContent')){
                            //mainFocusObj.TyreInterior[fileSourceType].inputFields[j].value = e.target.result;
                            var base64Img = e.target.result;
                            var base64result = base64Img.split(',')[1];
                            mainFocusObj.TyreInterior[fileSourceType].inputFields[j].value = base64result; //base64Img.replace("data:image/png;base64,", "");//e.target.result;

                        }                        
                        
                        component.set('v.allTyreInteriorOptions',mainFocusObj);   
                    }
                    }
                    if(areaName=='AnyArea'){
                    for(var j=0;j<mainFocusObj.AnyArea[fileSourceType].inputFields.length;j++){
                        
                        if(mainFocusObj.AnyArea[fileSourceType].inputFields[j].label.includes('strFileName')){
                            mainFocusObj.AnyArea[fileSourceType].inputFields[j].value = e.target.name;
                        }
                        if(mainFocusObj.AnyArea[fileSourceType].inputFields[j].label.includes('strFileType')){
                            mainFocusObj.AnyArea[fileSourceType].inputFields[j].value = e.target.type;
                        }
                        if(mainFocusObj.AnyArea[fileSourceType].inputFields[j].label.includes('fileSourceType')){
                            mainFocusObj.AnyArea[fileSourceType].inputFields[j].value = fileSourceType;
                        }
                        if(mainFocusObj.AnyArea[fileSourceType].inputFields[j].label.includes('fileContent')){
                           // mainFocusObj.AnyArea[fileSourceType].inputFields[j].value = e.target.result;
                            var base64Img = e.target.result;
                            var base64result = base64Img.split(',')[1];
                            mainFocusObj.AnyArea[fileSourceType].inputFields[j].value = base64result; //base64Img.replace("data:image/png;base64,", "");//e.target.result;
                        }                        
                        
                        component.set('v.allAnyAreaOptions',mainFocusObj);   
                    }
                    }
                    
                    //Section 2,3,4,5                    
                    if(areaName=='HolesandInjuries'){
                        for(var j=0;j<mainFocusObj.HolesandInjuries[fileSourceType].inputFields.length;j++){
                            
                            if(mainFocusObj.HolesandInjuries[fileSourceType].inputFields[j].label.includes('strFileName')){
                                mainFocusObj.HolesandInjuries[fileSourceType].inputFields[j].value = e.target.name;
                            }
                            if(mainFocusObj.HolesandInjuries[fileSourceType].inputFields[j].label.includes('strFileType')){
                                mainFocusObj.HolesandInjuries[fileSourceType].inputFields[j].value = e.target.type;
                            }
                            if(mainFocusObj.HolesandInjuries[fileSourceType].inputFields[j].label.includes('fileSourceType')){
                                mainFocusObj.HolesandInjuries[fileSourceType].inputFields[j].value = fileSourceType;
                            }
                            if(mainFocusObj.HolesandInjuries[fileSourceType].inputFields[j].label.includes('fileContent')){
                                //mainFocusObj.HolesandInjuries[fileSourceType].inputFields[j].value = e.target.result;
                                var base64Img = e.target.result;
                                var base64result = base64Img.split(',')[1];
                                mainFocusObj.HolesandInjuries[fileSourceType].inputFields[j].value = base64result; //base64Img.replace("data:image/png;base64,", "");//e.target.result;
                            }                        
                            
                            component.set('v.allHolesandInjuriesOptions',mainFocusObj);   
                        }
                    }
                    if(areaName=='MissingLooseTread'){
                        for(var j=0;j<mainFocusObj.MissingLooseTread[fileSourceType].inputFields.length;j++){
                            
                            if(mainFocusObj.MissingLooseTread[fileSourceType].inputFields[j].label.includes('strFileName')){
                                mainFocusObj.MissingLooseTread[fileSourceType].inputFields[j].value = e.target.name;
                            }
                            if(mainFocusObj.MissingLooseTread[fileSourceType].inputFields[j].label.includes('strFileType')){
                                mainFocusObj.MissingLooseTread[fileSourceType].inputFields[j].value = e.target.type;
                            }
                            if(mainFocusObj.MissingLooseTread[fileSourceType].inputFields[j].label.includes('fileSourceType')){
                                mainFocusObj.MissingLooseTread[fileSourceType].inputFields[j].value = fileSourceType;
                            }
                            if(mainFocusObj.MissingLooseTread[fileSourceType].inputFields[j].label.includes('fileContent')){
                                mainFocusObj.MissingLooseTread[fileSourceType].inputFields[j].value = e.target.result;
                                var base64Img = e.target.result;
                                var base64result = base64Img.split(',')[1];
                                mainFocusObj.MissingLooseTread[fileSourceType].inputFields[j].value = base64result; //base64Img.replace("data:image/png;base64,", "");//e.target.result;
                            }                        
                            
                            component.set('v.allMissingLooseTreadOptions',mainFocusObj);   
                        }               
                    }
                    if(areaName=='Cracks'){
                        for(var j=0;j<mainFocusObj.Cracks[fileSourceType].inputFields.length;j++){
                            
                            if(mainFocusObj.Cracks[fileSourceType].inputFields[j].label.includes('strFileName')){
                                mainFocusObj.Cracks[fileSourceType].inputFields[j].value = e.target.name;
                            }
                            if(mainFocusObj.Cracks[fileSourceType].inputFields[j].label.includes('strFileType')){
                                mainFocusObj.Cracks[fileSourceType].inputFields[j].value = e.target.type;
                            }
                            if(mainFocusObj.Cracks[fileSourceType].inputFields[j].label.includes('fileSourceType')){
                                mainFocusObj.Cracks[fileSourceType].inputFields[j].value = fileSourceType;
                            }
                            if(mainFocusObj.Cracks[fileSourceType].inputFields[j].label.includes('fileContent')){
                                //mainFocusObj.Cracks[fileSourceType].inputFields[j].value = e.target.result;
                                var base64Img = e.target.result;
                                var base64result = base64Img.split(',')[1];
                                mainFocusObj.Cracks[fileSourceType].inputFields[j].value = base64result; //base64Img.replace("data:image/png;base64,", "");//e.target.result;
                            }                        
                            
                            component.set('v.allCracksOptions',mainFocusObj);   
                        }
                    }
                    if(areaName=='BulgesDepressions'){
                        for(var j=0;j<mainFocusObj.BulgesDepressions[fileSourceType].inputFields.length;j++){
                            
                            if(mainFocusObj.BulgesDepressions[fileSourceType].inputFields[j].label.includes('strFileName')){
                                mainFocusObj.BulgesDepressions[fileSourceType].inputFields[j].value = e.target.name;
                            }
                            if(mainFocusObj.BulgesDepressions[fileSourceType].inputFields[j].label.includes('strFileType')){
                                mainFocusObj.BulgesDepressions[fileSourceType].inputFields[j].value = e.target.type;
                            }
                            if(mainFocusObj.BulgesDepressions[fileSourceType].inputFields[j].label.includes('fileSourceType')){
                                mainFocusObj.BulgesDepressions[fileSourceType].inputFields[j].value = fileSourceType;
                            }
                            if(mainFocusObj.BulgesDepressions[fileSourceType].inputFields[j].label.includes('fileContent')){
                                //mainFocusObj.BulgesDepressions[fileSourceType].inputFields[j].value = e.target.result;
                                var base64Img = e.target.result;
                                var base64result = base64Img.split(',')[1];
                                mainFocusObj.BulgesDepressions[fileSourceType].inputFields[j].value = base64result; //base64Img.replace("data:image/png;base64,", "");//e.target.result;
                            }                        
                            
                            component.set('v.allBulgesDepressionsOptions',mainFocusObj);   
                        }
                    }
                    if(areaName=='Miscellaneous'){
                        for(var j=0;j<mainFocusObj.Miscellaneous[fileSourceType].inputFields.length;j++){
                            
                            if(mainFocusObj.Miscellaneous[fileSourceType].inputFields[j].label.includes('strFileName')){
                                mainFocusObj.Miscellaneous[fileSourceType].inputFields[j].value = e.target.name;
                            }
                            if(mainFocusObj.Miscellaneous[fileSourceType].inputFields[j].label.includes('strFileType')){
                                mainFocusObj.Miscellaneous[fileSourceType].inputFields[j].value = e.target.type;
                            }
                            if(mainFocusObj.Miscellaneous[fileSourceType].inputFields[j].label.includes('fileSourceType')){
                                mainFocusObj.Miscellaneous[fileSourceType].inputFields[j].value = fileSourceType;
                            }
                            if(mainFocusObj.Miscellaneous[fileSourceType].inputFields[j].label.includes('fileContent')){
                                //mainFocusObj.Miscellaneous[fileSourceType].inputFields[j].value = e.target.result;
                                var base64Img = e.target.result;
                                var base64result = base64Img.split(',')[1];
                                mainFocusObj.Miscellaneous[fileSourceType].inputFields[j].value = base64result; //base64Img.replace("data:image/png;base64,", "");//e.target.result;
                            }                        
                            
                            component.set('v.allMiscellaneousOptions',mainFocusObj);   
                        }
                    }
                    
                    
                    fileUploadWrapper.push({
                        'strFileName':e.target.name,
                        'strFileType':e.target.type,
                        'fileSourceType':fileSourceType,
                        'fileContent':e.target.result,
                        'strRejectionName':'',
                        'parentId':''
                    });
                    contentWrapperArr.push({
                        'strFileName':e.target.name,
                        'strFileType':e.target.type,
                        'fileSourceType':fileSourceType,
                        'fileContent':e.target.result,
                        'strRejectionName':'',
                        'parentId':''
                    });
                }
                
                function handleEvent(event) {
                    if(contentWrapperArr.length == i){
                        console.log(JSON.stringify(fileUploadWrapper));
                        component.set("v.FileWrapper",fileUploadWrapper);
                        
                        //console.log(JSON.stringify(component.get('v.allBeadAreaOptions')));
                        console.log(JSON.stringify(component.get('v.allSidewallAreaOptions')));
                    }
                }
                
                reader.readAsDataURL(file);
                reader.addEventListener('loadend', handleEvent);
                
            }
        }
        
        
        
        
        
        /*
            var aa = event.getSource().get("v.name");
            var fileName1 = event.getSource().get("v.files");
            
            console.log('aa: '+aa);
            console.log('fileName1: '+fileName1);
            for (var i = 0; i < fileName1.length; i++) {
                
                console.log(fileName1[i].name+' : '+fileName1[i].type);
                
                //Filelist.push({Name :fileName1[i].name,Id : aa});
                //allBead[aa].fileName = fileName1[i].name;
                
            }
            /*component.set('v.allBeadAreaOptions', allBead);
            files.push(fileName1);
            component.set("v.fileToBeUploaded",files);
            console.log('Filelist',files);*/
        
        // component.set("v.fileName", Filelist);*/
    },
    
    handleOnIncrement: function(component, event, helper){
        var index = parseInt(event.getSource().get("v.value"));
        var selectedCutsNTCList = component.get("v.selectedCutsNTCList");
        //console.log('@@@@  ',  selectedCutsNTCList[index])
        selectedCutsNTCList[index].selectedValue++;
        component.set("v.selectedCutsNTCList", selectedCutsNTCList);
        
    },
    handleOnDecrement: function(component, event, helper){
        var index = parseInt(event.getSource().get("v.value"));
        var selectedCutsNTCList = component.get("v.selectedCutsNTCList");
        //console.log('@@@@  ',  selectedCutsNTCList[index])
        selectedCutsNTCList[index].selectedValue--;
        component.set("v.selectedCutsNTCList", selectedCutsNTCList);
    }
})