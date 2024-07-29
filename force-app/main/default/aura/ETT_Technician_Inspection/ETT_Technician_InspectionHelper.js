({
    showErrorToast: function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams(params);
            toastEvent.fire();
        } else {
            alert(params.message);
        }
    },
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            objObject: component.get("v.objInfo"),
            fld: fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    handleOnGoodConditionsChange: function(component, goodCondistionId, status) {
        var mainFocusObj = {};
        
        //pushing data into TyreRejectionLineItem Wrapper***************************
        var TyreRejectionLineItem = component.get("v.TyreRejectionLineItem");
        var found = false;
        for (var i = 0; i < TyreRejectionLineItem.length; i++) {
            if (TyreRejectionLineItem[i].tyreRejectionName == goodCondistionId) {
                found = true;
            }
        }
        
        if (found == false) {
            TyreRejectionLineItem.push({
                tyreRejectionName: goodCondistionId,
                goodCondition: status,
                lstTyreRejectionSubLineItems: null
            });
            //                'strRecordTypeName':'0123M0000008iGUQAY',
            
            component.set("v.TyreRejectionLineItem", TyreRejectionLineItem);
        }
        
        switch (goodCondistionId) {
            case "BeadArea":
                mainFocusObj = component.get("v.allBeadAreaOptions");
                mainFocusObj.selectedStatus = status;
                component.set("v.allBeadAreaOptions", mainFocusObj);
                break;
            case "SideWallArea":
                mainFocusObj = component.get("v.allSidewallAreaOptions");
                mainFocusObj.selectedStatus = status;
                component.set("v.allSidewallAreaOptions", mainFocusObj);
                break;
            case "CrownArea":
                mainFocusObj = component.get("v.allCrownAreaOptions");
                mainFocusObj.selectedStatus = status;
                component.set("v.allCrownAreaOptions", mainFocusObj);
                break;
            case "TyreInterior":
                mainFocusObj = component.get("v.allTyreInteriorOptions");
                mainFocusObj.selectedStatus = status;
                component.set("v.allTyreInteriorOptions", mainFocusObj);
                break;
            case "AnyArea":
                mainFocusObj = component.get("v.allAnyAreaOptions");
                mainFocusObj.selectedStatus = status;
                component.set("v.allAnyAreaOptions", mainFocusObj);
                break;
            case "HolesandInjuries":
                mainFocusObj = component.get("v.allHolesandInjuriesOptions");
                mainFocusObj.selectedStatus = status;
                component.set("v.allHolesandInjuriesOptions", mainFocusObj);
                break;
            case "MissingLooseTread":
                mainFocusObj = component.get("v.allMissingLooseTreadOptions");
                mainFocusObj.selectedStatus = status;
                component.set("v.allMissingLooseTreadOptions", mainFocusObj);
                break;
            case "Cracks":
                mainFocusObj = component.get("v.allCracksOptions");
                mainFocusObj.selectedStatus = status;
                component.set("v.allCracksOptions", mainFocusObj);
                break;
            case "BulgesDepressions":
                mainFocusObj = component.get("v.allBulgesDepressionsOptions");
                mainFocusObj.selectedStatus = status;
                component.set("v.allBulgesDepressionsOptions", mainFocusObj);
                break;
            case "Miscellaneous":
                mainFocusObj = component.get("v.allMiscellaneousOptions");
                mainFocusObj.selectedStatus = status;
                component.set("v.allMiscellaneousOptions", mainFocusObj);
                break;
            default:
                
                // code block
        }
    },
    setBeadAreaPickListValue: function(component) {
        var opts = [
            {
                class: "optionClass",
                label: "-None-",
                value: ""
            },
            {
                class: "optionClass",
                label: "Yes",
                value: "Yes"
            },
            {
                class: "optionClass",
                label: "No",
                value: "No"
            }
        ];
        /*var opts = [{
                class: "optionClass",
                label: '-None-',
                value: ''
            },
            {
                class: "optionClass",
                label: 'Good Condition',
                value: 'Good Condition'
            },{
               class: "optionClass",
                label: 'Torn Bead',
                value: 'Torn Bead'
            },{
               class: "optionClass",
                label: 'Kinked/Distorted Beads Condition',
                value: 'Kinked/Distorted Beads Condition'
            },{
               class: "optionClass",
                label: 'Bead Deformation',
                value: 'Bead Deformation'
            },{
                class: "optionClass",
                label: 'Burned Beads',
                value: 'Burned Beads'
            },{
               class: "optionClass",
                label: 'Reinforce / Chafer Separation',
                value: 'Reinforce / Chafer Separation'
            },{
               class: "optionClass",
                label: 'Petro/ Lubricant Damage',
                value: 'Petro/ Lubricant Damage'
            },{
               class: "optionClass",
                label: 'Bead Damage From Curbing',
                value: 'Bead Damage From Curbing'
            },{
               class: "optionClass",
                label: 'Bead Area Flow Crack',
                value: 'Bead Area Flow Crack'
            }];*/
      
      component.find("beadArea").set("v.options", opts);
  },
    setBeadAreaPickListValue1: function(component) {
        try {
            var options = [
                {
                    class: "optionClass",
                    label: "None",
                    value: ""
                },
                {
                    class: "optionClass",
                    label: "Rejected",
                    value: "Rejected"
                },
                {
                    class: "optionClass",
                    label: "Accepted",
                    value: "Accepted"
                }
            ];
             var options2 = [{
                class: "optionClass",
                label: "0%",
                value: "0%"
                
            },{
                class: "optionClass",
                label: "10%",
                value: "10%"
            },
            {
              class: "optionClass",
              label: "20%",
              value: "20%"
            },
            {
                class: "optionClass",
                label: "30%",
                value: "30%"
            },
            {
              class: "optionClass",
              label: "40%",
              value: "40%"
            },
            {
                class: "optionClass",
                label: "50%",
                value: "50%"
            },
            {
              class: "optionClass",
              label: "60%",
              value: "60%"
            },
            {
                class: "optionClass",
                label: "70%",
                value: "70%"
            },
            {
              class: "optionClass",
              label: "80%",
              value: "80%"
            },
            {
                class: "optionClass",
                label: "90%",
                value: "90%"
            },
            {
              class: "optionClass",
              label: "100%",
              value: "100%"
            }                  
           ];
            
            var inputFields1 = [
                {
                    label: "Rejection Name",
                    value: "Torn Bead"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Torn_Bead_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Torn_Bead_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields2 = [
                {
                    label: "Rejection Name",
                    value: "Kinked/Distorted Beads Condition"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Kinked_Distorted_Beads_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get(
                        "$Label.c.ETT_Bead_Kinked_Distorted_Beads_Recommendations"
                    )
                },
                {
                    label: "Percentage",
                    value:options2,
                    selectedVal :"0%"
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields3 = [
                {
                    label: "Rejection Name",
                    value: "Bead Deformation"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Bead_Bead_Deformation_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Bead_Bead_Deformation_Recommendation")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields4 = [
                {
                    label: "Rejection Name",
                    value: "Burned Beads"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Bead_Burned_Beads_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Bead_Burned_Beads_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields5 = [
                {
                    label: "Rejection Name",
                    value: "Reinforce / Chafer Separation"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get(
                        "$Label.c.ETT_Bead_Reinforce_Chafer_Seperation_Probable_Cause"
                    )
                },
                {
                    label: "Recommendation",
                    value: $A.get(
                        "$Label.c.ETT_Bead_Reinforce_Chafer_Seperation_Recommendation"
                    )
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields6 = [
                {
                    label: "Rejection Name",
                    value: "Petro/ Lubricant Damage"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get(
                        "$Label.c.ETT_Bead_Petro_Lubricant_Damage_Probable_Cause"
                    )
                },
                {
                    label: "Recommendation",
                    value: $A.get(
                        "$Label.c.ETT_Band_Petro_Lubricant_Damage_Recommendations"
                    )
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields7 = [
                {
                    label: "Rejection Name",
                    value: "Bead Damage From Curbing"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get(
                        "$Label.c.ETT_Bead_Bead_Damage_From_Curbing_Probable_Cause"
                    )
                },
                {
                    label: "Recommendation",
                    value: ""
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields8 = [
                {
                    label: "Rejection Name",
                    value: "Bead Area Flow Crack"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Bead_Bead_Area_Flow_Crack_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get(
                        "$Label.c.ETT_Bead_Bead_Area_Flow_Crack_Recommendations"
                    )
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Torn Bead",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Torn_Bead")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Kinked/Distorted Beads Condition",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Kinked_Distorted_Beads")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Bead Deformation",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Bead_Deformation")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Burned Beads",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Burned_Beads")
                },
                {
                    inputFields: inputFields5,
                    options: options,
                    label: "Reinforce / Chafer Separation",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Reinforce_Chafer_Separation")
                },
                {
                    inputFields: inputFields6,
                    options: options,
                    label: "Petro/ Lubricant Damage",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Petro_Lubricant_Damage")
                },
                {
                    inputFields: inputFields7,
                    options: options,
                    label: "Bead Damage From Curbing",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Bead_Damage_from_Curbing")
                },
                {
                    inputFields: inputFields8,
                    options: options,
                    label: "Bead Area Flow Crack",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Bead_Area_Flow_Crack")
                },
            ];
            
            var status = [
                /*{
                    class: "optionClass",
                    label: "-None-",
                    value: ""
                },*/
                {
                    class: "optionClass",
                    label: "Yes",
                    value: "Yes"
                },
                {
                    class: "optionClass",
                    label: "No",
                    value: "No"
                }
            ];
            
            var checkbox4 = [
                {
                    label: "Bead wire loosening",
                    value: false
                },
                {
                    label: "Bead bundle crack",
                    value: false
                },
                {
                    label: "Turn up / Chafour Loose",
                    value: false
                },
                {
                    label: "Hard Bead",
                    value: false
                }
            ];
            
            var allBeadAreaOptions = {
                goodConditionsOption: status,
                BeadArea: opts,
                selectedStatus: "",
                checkboxList : checkbox4
            };
            component.set("v.allBeadAreaOptions", allBeadAreaOptions);
            // component.set('v.allBeadAreaOptions', opts);
        } catch (err) {
            alert(err.message);
        }
    },
    setValueForSidewallArea: function(component) {
        try {
            var options = [
                {
                    class: "optionClass",
                    label: "None",
                    value: ""
                },{
                    class: "optionClass",
                    label: "Rejected",
                    value: "Rejected"
                },
                {
                    class: "optionClass",
                    label: "Accepted",
                    value: "Accepted"
                }
            ];
            var optionss2 = [{
                class: "optionClass",
                label: "0",
                value: "0"
                
            },{
                class: "optionClass",
                label: "1",
                value: "1"
            },
            {
              class: "optionClass",
              label: "2",
              value: "2"
            },
            {
                class: "optionClass",
                label: "3",
                value: "3"
            },
            {
              class: "optionClass",
              label: "4",
              value: "4"
            },
            {
                class: "optionClass",
                label: "5",
                value: "5"
            },
            {
              class: "optionClass",
              label: "6",
              value: "6"
            },
            {
                class: "optionClass",
                label: "7",
                value: "7"
            },
            {
              class: "optionClass",
              label: "8",
              value: "8"
            },
            {
                class: "optionClass",
                label: "9",
                value: "9"
            },
            {
              class: "optionClass",
              label: "10",
              value: "10"
            }                  
           ];
            var options2 = [{
                class: "optionClass",
                label: "0%",
                value: "0%"
                
            },{
                class: "optionClass",
                label: "10%",
                value: "10%"
            },
            {
              class: "optionClass",
              label: "20%",
              value: "20%"
            },
            {
                class: "optionClass",
                label: "30%",
                value: "30%"
            },
            {
              class: "optionClass",
              label: "40%",
              value: "40%"
            },
            {
                class: "optionClass",
                label: "50%",
                value: "50%"
            },
            {
              class: "optionClass",
              label: "60%",
              value: "60%"
            },
            {
                class: "optionClass",
                label: "70%",
                value: "70%"
            },
            {
              class: "optionClass",
              label: "80%",
              value: "80%"
            },
            {
                class: "optionClass",
                label: "90%",
                value: "90%"
            },
            {
              class: "optionClass",
              label: "100%",
              value: "100%"
            }                  
           ];
            var inputFields1 = [
                {
                    label: "Rejection Name",
                    value: "Spread/Damaged Cord"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields2 = [
                {
                    label: "Rejection Name",
                    value: "Cuts and Snags"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
                },
                {
                    label: "No of Cuts",
                    value: optionss2,
                    selectedVal : "0"
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields3 = [
                {
                    label: "Rejection Name",
                    value: "Sidewall Separation"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Sidewall_Seperation_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Sidewall_Seperation_Recommendations")
                },
                {
                    label: "No of Separation",
                    value: optionss2,
                    selectedVal : "0"
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields4 = [
                {
                    label: "Rejection Name",
                    value: "Chain Damage"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Chain_Damage_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Chain_Damage_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields5 = [
                {
                    label: "Rejection Name",
                    value: "Vehicle/Equipment Damage"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Vehicle_Equipment_Damage_Probable_Cause"
                    )
                },
                {
                    label: "Recommendation",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Vehicle_Equipment_Damage_Recommendations"
                    )
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields6 = [
                {
                    label: "Rejection Name",
                    value: "Damage Induced Sidewall Separation"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Damaged_Induced_Sidewall_Separation_Probable_Cause"
                    )
                },
                {
                    label: "Recommendation",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Damaged_Induced_Sidewall_Separation_Recommendations"
                    )
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields7 = [
                {
                    label: "Rejection Name",
                    value: "Sidewall Abrasion/Scuff Damage"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Sidewall_Abrasion_Scuff_Damage_Probable_Cause"
                    )
                },
                {
                    label: "Recommendation",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Sidewall_Abrasion_Scuff_Damage_Recommendations"
                    )
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields8 = [
                {
                    label: "Rejection Name",
                    value: "Aging Crack/Weathering"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Weathering_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_SWA_Weathering_Recommendations")
                },
                {
                    label: "Percentage",
                    value:options2,
                    selectedVal :"0%"
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields9 = [
                {
                    label: "Rejection Name",
                    value: "Impact Break"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Impact_Break_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_SWA_Impact_Break_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields10 = [
                {
                    label: "Rejection Name",
                    value: "Branding Damage"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Branding_Damage_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_SWA_Branding_Damage_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields11 = [
                {
                    label: "Rejection Name",
                    value: "Diagonal Cracking"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Diagonal_Cracking_Probale_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_SWA_Diagonal_Cracking_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields12 = [
                {
                    label: "Rejection Name",
                    value: "Petroleum Product Damage"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Petroleum_Product_Damage_Probable_Cause"
                    )
                },
                {
                    label: "Recommendation",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Petroleum_Product_Damage_Recommendations"
                    )
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields13 = [
                {
                    label: "Rejection Name",
                    value: "Forklift Damage"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Forklift_Damage_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_SWA_Forklift_Damage_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields14 = [
                {
                    label: "Rejection Name",
                    value: "Circumferential Fatigue Rupture (Zipper)"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Circumferential_Fatigue_Repture_Probable_Cause"
                    )
                },
                {
                    label: "Recommendation",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Circumferential_Fatigue_Repture_Recommendations"
                    )
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields15 = [
                {
                    label: "Rejection Name",
                    value: "Open Sidewall Splice"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Open_sidewall_Splice_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_SWA_Open_sidewall_Splice_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields16 = [
                {
                    label: "Rejection Name",
                    value: "Sidewall Bumps (Blisters)"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Sidewall_Bumps_Blisters_Probable_Cause"
                    )
                },
                {
                    label: "Recommendation",
                    value: $A.get(
                        "$Label.c.ETT_SWA_Sidewall_Bumps_Blisters_Recommendations"
                    )
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields17 = [
                {
                    label: "Rejection Name",
                    value: "Sidewall Penetration"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Sidewall_Penetration_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_SWA_Sidewall_Penetration_recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields18 = [
                {
                    label: "Rejection Name",
                    value: "Radial Split"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_SWA_Redial_Split_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_SWA_Redial_Split_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Spread/Damaged Cord",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Cuts and Snags",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Sidewall Separation",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SidewallSeparation")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Chain Damage",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_ChainDamage")
                },
                {
                    inputFields: inputFields5,
                    options: options,
                    label: "Vehicle/Equipment Damage",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_VehicleDamage")
                },
                {
                    inputFields: inputFields6,
                    options: options,
                    label: "Damage Induced Sidewall Separation",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_DamagedInducedSeparation")
                },
                {
                    inputFields: inputFields7,
                    options: options,
                    label: "Sidewall Abrasion/Scuff Damage",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SidewallAbrasionScuffDamage")
                },
                {
                    inputFields: inputFields8,
                    options: options,
                    label: "Aging Crack/Weathering",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_Weathering")
                },
                {
                    inputFields: inputFields9,
                    options: options,
                    label: "Impact Break",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_ImpactBreak")
                },
                {
                    inputFields: inputFields10,
                    options: options,
                    label: "Branding Damage",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_BrandingDamage")
                },
                {
                    inputFields: inputFields11,
                    options: options,
                    label: "Diagonal Cracking",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_DiagnoalCracking")
                },
                {
                    inputFields: inputFields12,
                    options: options,
                    label: "Petroleum Product Damage",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_PetroleumProductDamage")
                },
                {
                    inputFields: inputFields13,
                    options: options,
                    label: "Forklift Damage",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_ForkliftDamage")
                },
                {
                    inputFields: inputFields14,
                    options: options,
                    label: "Circumferential Fatigue Rupture (Zipper)",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CircumFatigueRupture")
                },
                {
                    inputFields: inputFields15,
                    options: options,
                    label: "Open Sidewall Splice",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_OpensidewallSplice")
                },
                {
                    inputFields: inputFields16,
                    options: options,
                    label: "Sidewall Bumps (Blisters)",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SidewallBumps")
                },
                {
                    inputFields: inputFields17,
                    options: options,
                    label: "Sidewall Penetration",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SidewallPenetration")
                },
                {
                    inputFields: inputFields18,
                    options: options,
                    label: "Radial Split",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_RadialSplit")
                }
            ];
            var status = [
                /*{
                    class: "optionClass",
                    label: "-None-",
                    value: ""
                },*/
                {
                    class: "optionClass",
                    label: "Yes",
                    value: "Yes"
                },
                {
                    class: "optionClass",
                    label: "No",
                    value: "No"
                }
            ];
            var allSidewallAreaOptions = {
                goodConditionsOption: status,
                SidewallArea: opts,
                selectedStatus: ""
            };
            component.set("v.allSidewallAreaOptions", allSidewallAreaOptions);
        } catch (err) {
            alert(err.message);
        }
    },
    setValueForCrownArea: function(component) {
        try {
            var options = [{
                class: "optionClass",
                label: "None",
                value: ""
            },{
                class: "optionClass",
                label: "Rejected",
                value: "Rejected"
            },
            {
              class: "optionClass",
              label: "Accepted",
              value: "Accepted"
            }
           ];
            var options2 = [{
                class: "optionClass",
                label: "0%",
                value: "0%"
                
            },{
                class: "optionClass",
                label: "10%",
                value: "10%"
            },
            {
              class: "optionClass",
              label: "20%",
              value: "20%"
            },
            {
                class: "optionClass",
                label: "30%",
                value: "30%"
            },
            {
              class: "optionClass",
              label: "40%",
              value: "40%"
            },
            {
                class: "optionClass",
                label: "50%",
                value: "50%"
            },
            {
              class: "optionClass",
              label: "60%",
              value: "60%"
            },
            {
                class: "optionClass",
                label: "70%",
                value: "70%"
            },
            {
              class: "optionClass",
              label: "80%",
              value: "80%"
            },
            {
                class: "optionClass",
                label: "90%",
                value: "90%"
            },
            {
              class: "optionClass",
              label: "100%",
              value: "100%"
            }                  
           ];
             var options3 = [{
                class: "optionClass",
                label: "0mm",
                value: "0mm"
            },{
                class: "optionClass",
                label:"1mm",
                value:"1mm"
            },
            {
              class: "optionClass",
              label:"2mm",
              value:"2mm"
            },
            {
                class: "optionClass",
                label:"3mm",
                value:"3mm"
            },
            {
              class: "optionClass",
              label:"4mm",
              value:"4mm"
            },
            {
                class: "optionClass",
                label:"5mm",
                value:"5mm"
            },
            {
              class: "optionClass",
              label:"6mm",
              value:"6mm"
            },
            {
                class: "optionClass",
                label:"7mm",
              	value:"7mm"
            },
            {
              class: "optionClass",
              label:"8mm",
              value:"8mm"
            },
            {
                class: "optionClass",
                label:"9mm",
              	value:"9mm"
            },
            {
              class: "optionClass",
              label:"10mm",
              value:"10mm"
            },
            {
                class: "optionClass",
                label: "11mm",
                value: "11mm"
            },{
                class: "optionClass",
                label:"12mm",
                value:"12mm"
            },
            {
              class: "optionClass",
              label:"13mm",
              value:"13mm"
            },
            {
                class: "optionClass",
                label:"14mm",
                value:"14mm"
            },
            {
              class: "optionClass",
              label:"15mm",
              value:"15mm"
            },
            {
                class: "optionClass",
                label:"16mm",
                value:"16mm"
            },
            {
              class: "optionClass",
              label:"17mm",
              value:"17mm"
            },
            {
                class: "optionClass",
                label:"18mm",
              	value:"18mm"
            },
            {
              class: "optionClass",
              label:"19mm",
              value:"19mm"
            },
            {
                class: "optionClass",
                label:"20mm",
              	value:"20mm"
            },
            {
              class: "optionClass",
              label:"21mm",
              value:"21mm"
            },
            {
              class: "optionClass",
              label:"22mm",
              value:"22mm"
            }                 
           ];
            //Start-Added By Jana
            var checkbox1 = [
                {
                    label: "Buttress Crack/ Shoulder Crack",
                    value: false
                },
                {
                    label: "Strain Mark",
                    value: false
                },
                {
                    label: "Uneven wear",
                    value: false
                },
                
            ];
                
                var options4 = [{
                class: "optionClass",
                label: "Nil",
                value: "Nil",
                selected:"true"
                },{
                class: "optionClass",
                label:"5%",
                value:"5%"
                
                },
                {
                class: "optionClass",
                label:"10%",
                value:"10%"
                },
                {
                class: "optionClass",
                label:"15%",
                value:"15%"
                },
                {
                class: "optionClass",
                label:"20%",
                value:"20%"
                },
                {
                class: "optionClass",
                label:"25%",
                value:"25%"
                },
                {
                class: "optionClass",
                label:"30%",
                value:"30%"
                },
                {
                class: "optionClass",
                label:"35%",
                value:"35%"
                },
                {
                class: "optionClass",
                label:"40%",
                value:"40%"
                },
                {
                class: "optionClass",
                label:"45%",
                value:"45%"
                },
                {
                class: "optionClass",
                label:"50%",
                value:"50%"
                },
                {
                class: "optionClass",
                label: "55%",
                value: "55%"
                },{
                class: "optionClass",
                label:"60%",
                value:"60%"
                },
                {
                class: "optionClass",
                label:"65%",
                value:"65%"
                },
                {
                class: "optionClass",
                label:"70%",
                value:"70%"
                },
                {
                class: "optionClass",
                label:"75%",
                value:"75%"
                },
                {
                class: "optionClass",
                label:"80%",
                value:"80%"
                },
                {
                class: "optionClass",
                label:"85%",
                value:"85%"
                },
                {
                class: "optionClass",
                label:"90%",
                value:"90%"
                },
                {
                class: "optionClass",
                label:"95%",
                value:"95%"
                },
                {
                class: "optionClass",
                label:"100%",
                value:"100%"
                }            
            ];
            
            var optionlist = [
                {
                    label:'Groove/Channel Crack',
                    options:options4,
                    selectedValue:""
                    
                },
                {
                    label:'Thread wornout',
                    options:options4,
                    selectedValue:""
                },
                {
                    label:'Excessive One sided wear',
                    options:options4,
                    selectedValue:""
                    
                }
                
            ];
            ///End By Jana
            var inputFields01 = [{
                label: 'Rejection Name',
                value: 'Steer Axle Shoulder Step/Chamfer Wear'
 
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_Crown_Shoulderstep_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Crown_Shoulderstep_Recommendations")
            },
            {
                label: "Percentage",
                value: options2,
                selectedVal : "0%"
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields02 = [{
                label: 'Rejection Name',
                value: 'Full Shoulder Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_Crown_fullShoulder_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Crown_fullShoulder_Recommendations")
            },
            {
                label: "Percentage",
                value: options2,
                selectedVal : "0%"
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields03 = [{
                label: 'Rejection Name',
                value: 'Feather Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_crown_area_feather_wear_Probable"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_crown_area_feather_wear_recommendation")
            },
             {
                label: "Percentage",
                value: options2,
                selectedVal : "0%"
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields04 = [{
                label: 'Rejection Name',
                value: 'Erosion/River/Channel Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_crown_area_erosion_Probable_cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_crown_area_erosion_recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields05 = [{
                label: 'Rejection Name',
                value: 'Cupping/Scallop Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_Cupping_Scallop_Wear_Probable"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Cuppingrecommendation")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields06 = [{
                label: 'Rejection Name',
                value: 'Steer Axle One Sided Wear'

            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_One_Sided_Wear_Pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_One_Sided_Wear_Reco")
            },
             {
                label: "Percentage",
                value: options2,
                selectedVal : "0%"
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields07 = [{
                label: 'Rejection Name',
                value: 'Diagonal Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_crown_area_Diagonal_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_crown_area_Diagonal_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields08 = [{
                label: 'Rejection Name',
                value: 'Eccentric/Out-Of-Round Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_crown_area_Eccentric_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Crown_area_Eccentric_recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields09 = [{
                label: 'Rejection Name',
                value: 'Steer Axle Overall Fast Wear'

            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_Crown_area_Overall_Fast_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Crown_area_Overall_Fast_Wear_Recmo")
            },
             {
                label: "Thickness",
                value: options3,
                selectedVal : "0mm"
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields010 = [{
                label: 'Rejection Name',
                value: 'Rib Depression/Punch Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_Crown_area_Rib_Depression_Punch_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Crown_area_Rib_Crown_area_Depression_Punch_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields011 = [{
                label: 'Rejection Name',
                value: 'Erratic Depression Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_crown_areaErratic_Depression_Wear_Pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_crown_areaErratic_Depression_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields012 = [{
                label: 'Rejection Name',
                value: 'Drive Axle Shoulder Step/Chamfer Wear'

            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_CrownDrive_Axle_Shoulder_StepChamfer_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_CrownDrive_Axle_Shoulder_StepChamfer_Wear_Recom")
            },
            {
                label: "Percentage",
                value: options2,
                selectedVal : "0%"
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields013 = [{
                label: 'Rejection Name',
                value: 'Heel/Toe Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_crown_area_Heel_Toe_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_crown_area_Heel_Toe_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields014 = [{
                label: 'Rejection Name',
                value: 'Alternate Lug Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_crown_area_Alternate_Lug_Wear_Pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_crown_area_Alternate_Lug_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields015 = [{
                label: 'Rejection Name',
                value: 'Break Skid/Flat Spot Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_Crown_Break_Skid_Flat_Spot_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Crown_Break_Skid_Flat_Spot_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields016 = [{
                label: 'Rejection Name',
                value: 'Drive Axle Overall Fast Wear'

            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_Drive_Axle_Overall_Fast_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Drive_Axle_Overall_Fast_Wear_recom")
            },
             {
                label: "Percentage",
                value: options3,
                selectedVal : "0mm"
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            //
             var inputFields1 = [{
                label: 'Rejection Name',
                value: 'Break Skid Flat Spot Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_Crown_Break_Skid_Flat_Spot_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Crown_Break_Skid_Flat_Spot_Wear_pro")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields111 = [{
                label: 'Rejection Name',
                value: 'Break Skid Flat Spot Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_Trailer_axil_Break_Skid_Flat_Spot_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Trailer_axil_Break_Skid_Flat_Spot_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields2 = [{
                label: 'Rejection Name,',
                value: 'Diagonal Wear'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Trailer_axileDiagonal_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Trailer_axileDiagonal_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields3 = [{
                label: 'Rejection Name,',
                value: 'Multiple Flat Spotting Wire'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_CrownMultiple_Flat_Spotting_Wire_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_CrownMultiple_Flat_Spotting_Wire_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields333 = [{
                label: 'Rejection Name,',
                value: 'Multiple Flat Spotting Wire'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_CrownMultiple_Flat_Spotting_Wire_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_CrownMultiple_Flat_Spotting_Wire_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];

            var inputFields4 = [{
                label: 'Rejection Name,',
                value: 'Rapid Shoulder Wear – One Shoulder'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Rapid_Shoulder_Wear_One_Shoulder_PRO"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Rapid_Shoulder_Wear_One_Shoulder_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields44 = [{
                label: 'Rejection Name,',
                value: 'Rapid Shoulder Wear – One Shoulder'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Rapid_Shoulder_Wear_One_Shoulder_PRO"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Rapid_Shoulder_Wear_One_Shoulder_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
             var inputFields444 = [{
                label: 'Rejection Name,',
                value: 'Rapid Shoulder Wear – One Shoulder'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Rapid_Shoulder_Wear_One_Shoulder_PRO"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Rapid_Shoulder_Wear_One_Shoulder_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields5 = [{
                label: 'Rejection Name,',
                value: 'Shoulder Scrubbing/Scuffing Wear'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Shoulder_Scrubbing_Scuffing_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Shoulder_Scrubbing_Scuffing_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields6 = [{
                label: 'Rejection Name,',
                value: 'Rapid Shoulder Wear – Both Shoulder'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Rapid_Shoulder_Wear_BothShoulder_Pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Rapid_Shoulder_Wear_BothShoulder_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields66 = [{
                label: 'Rejection Name,',
                value: 'Rapid Shoulder Wear – Both Shoulder'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Rapid_Shoulder_Wear_BothShoulder_Pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Rapid_Shoulder_Wear_BothShoulder_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
             var inputFields666 = [{
                label: 'Rejection Name,',
                value: 'Rapid Shoulder Wear – Both Shoulder'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Rapid_Shoulder_Wear_BothShoulder_Pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Rapid_Shoulder_Wear_BothShoulder_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields7 = [{
                label: 'Rejection Name,',
                value: 'Erratic Depression Wear'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Erratic_Depression_Wear_Pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Erratic_Depression_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields8 = [{
                label: 'Rejection Name,',
                value: 'Trailer Axle One Sided Wear'

            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Trailer_Axle_One_Sided_Wear_pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Trailer_Axle_One_Sided_Wear_Recom")
            },
             {
                label: "Percentage",
                value: options2,
                selectedVal : "0%"
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            
            var inputFields9 = [{
                label: 'Rejection Name',
                value: 'Erosion/River/Channel Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_Erosion_RiverChannel_Pro"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Erosion_RiverChannel_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
            var inputFields10 = [{
                label: 'Rejection Name,',
                value: 'Rib Depression/Punch Wear'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_Rib_DepressionPunch_Wear_PRO"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_Rib_DepressionPunch_Wear_Recom")
            },{
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }];
        var inputFields11 = [
            {
                label: "Rejection Name,",
                value: "Penetrations and Road Hazards"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get(
                    "$Label.c.ETT_Crown_Penetrations_And_Road_Hazards_Probable_Cause"
                )
            },
            {
                label: "Recommendation",
                value: $A.get(
                    "$Label.c.ETT_Crown_Penetrations_And_Road_Hazards_Recommendations"
                )
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields12 = [
            {
                label: "Rejection Name,",
                value: "Vehicle Damage"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Vehicle_Damage_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Vehicle_Damage_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields13 = [
            {
                label: "Rejection Name,",
                value: "Forklift Damage/Cuts and Snags"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get(
                    "$Label.c.ETT_Crown_Forklift_Damage_Cuts_And_Snags_Probable_Cause"
                )
            },
            {
                label: "Recommendation",
                value: $A.get(
                    "$Label.c.ETT_Crown_Forklift_Damage_Cuts_And_Snags_Recommendations"
                )
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields14 = [
            {
                label: "Rejection Name,",
                value: "Belt lift/Separation"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get(
                    "$Label.c.ETT_Crown_Belt_Lift_Separation_Probable_Cause"
                )
            },
            {
                label: "Recommendation",
                value: $A.get(
                    "$Label.c.ETT_Crown_Belt_Lift_Separation_Recommendations"
                )
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields15 = [
            {
                label: "Rejection Name,",
                value: "Tread Lift/Separation"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get(
                    "$Label.c.ETT_Crown_Tread_Lift_Separation_Probable_Cause"
                )
            },
            {
                label: "Recommendation",
                value: $A.get(
                    "$Label.c.ETT_Crown_Tread_Lift_Separation_Recommendations"
                )
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields16 = [
            {
                label: "Rejection Name,",
                value: "Break Skid Damage"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Brake_Skid_Damage_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Brake_Skid_Damage_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields17 = [
            {
                label: "Rejection Name,",
                value: "Tread/Chunking"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Tread_Chunking_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Tread_Chunking_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields18 = [
            {
                label: "Rejection Name,",
                value: "Lug Base Cracking"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Lug_Base_Cracking_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Lug_Base_Cracking_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields19 = [
            {
                label: "Rejection Name,",
                value: " Wild Wire"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Wild_Wire_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Wild_Wire_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields20 = [
            {
                label: "Rejection Name",
                value: "Impact Break"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Impact_Breaks_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Impact_Breaks_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields21 = [
            {
                label: "Rejection Name,",
                value: "Chipping/Flaking/Chunking Tread"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get(
                    "$Label.c.ETT_Crown_Chipping_Flaking_Chunking_Tread_Probable_Cause"
                )
            },
            {
                label: "Recommendation",
                value: $A.get(
                    "$Label.c.ETT_Crown_Chipping_Flaking_Chunking_Tread_Recommendations"
                )
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields22 = [
            {
                label: "Rejection Name,",
                value: "Stone Drilling"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Stone_Drilling_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Stone_Drilling_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields23 = [
            {
                label: "Rejection Name,",
                value: "Regrooving Damage"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Re_grooving_Damage_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Re_grooving_Damage_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields24 = [
            {
                label: "Rejection Name,",
                value: "Dynamometer Type Damage"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get(
                    "$Label.c.ETT_Crown_Dynamometer_Type_Damage_Probable_Cause"
                )
            },
            {
                label: "Recommendation",
                value: $A.get(
                    "$Label.c.ETT_Crown_Dynamometer_Type_Damage_Recommendations"
                )
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields25 = [
            {
                label: "Rejection Name,",
                value: "Chemical Damage"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Chemical_Damage_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Chemical_Damage_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields26 = [
            {
                label: "Rejection Name,",
                value: "Excessive Wear"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Excessive_Wear_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Excessive_Wear_Probable_Caus")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields27 = [
            {
                label: "Rejection Name,",
                value: "Rib Tearing"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Rib_Tearing_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Rib_Tearing_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields28 = [
            {
                label: "Rejection Name,",
                value: "Defense Groove Tearing"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get(
                    "$Label.c.ETT_Crown_Defense_Groove_Tearing_Probable_Cause"
                )
            },
            {
                label: "Recommendation",
                value: $A.get(
                    "$Label.c.ETT_Crown_Defense_Groove_Tearing_Recommendations"
                )
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields29 = [
            {
                label: "Rejection Name,",
                value: "Groove Cracking"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Groove_Cracking_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Groove_Cracking_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields30 = [
            {
                label: "Rejection Name,",
                value: "Spin Damage"
            },
            {
                label: "Cause Of Rejection",
                value: $A.get("$Label.c.ETT_Crown_Spin_Damage_Probable_Cause")
            },
            {
                label: "Recommendation",
                value: $A.get("$Label.c.ETT_Crown_Spin_Damage_Recommendations")
            },
            {
                label: "Other",
                value: ""
            },
            {
                label: "strFileType",
                value: ""
            },
            {
                label: "strFileName",
                value: ""
            },
            {
                label: "fileContent",
                value: ""
            },
            {
                label: "strRejectionName",
                value: ""
            },
            {
                label: "parentId",
                value: ""
            }
        ];
        var inputFields001 =[{}];
        /*var inputFields002 =[{}];
        var inputFields003 =[{}];
        var inputFields004 =[{}];
        var inputFields005 =[{}];
        
        var inputFields006 =[{}];
        var inputFields007 =[{}];
        var inputFields008 =[{}]; */
            
        var opts = [
            {
              inputFields:inputFields01,
                options: options,
                label: 'Steer Axle Shoulder Step/Chamfer Wear',
                value: 'Steer Axle Shoulder Step/Chamfer Wear',
                imagelink: $A.get('$Resource.ETT_Crownarea_ShoulderStep'),
                tab: '1'
            },{
              inputFields:inputFields02,
                options: options,
                label: 'Full Shoulder Wear ',
                value: 'Full Shoulder Wear ',
                imagelink: $A.get('$Resource.ETT_Crownarea_FullShoulderwear'),
                tab: '1'
            },
             
           {
              inputFields:inputFields03,
                options: options,
                label: 'Feather Wear',
                value: 'Feather Wear',
                imagelink: $A.get('$Resource.ETT_Crownarea_featherwear'),
                tab: '1'
            },
            {
              inputFields:inputFields04,
                options: options,
                label: 'Erosion/River/Channel Wear',
                value: 'Erosion/River/Channel Wear',
                imagelink: $A.get('$Resource.ETT_Crownareaerosion'),
                tab: '1'
                
            },
           
           {
              inputFields:inputFields05,
                options: options,
                label: 'Cupping/Scallop Wear',
                value: 'Cupping/Scallop Wear',
                imagelink: $A.get('$Resource.ETT_Cupping_Wear'),
                 tab: '1'
            },{
              inputFields:inputFields06,
                options: options,
                label: 'Steer Axle One Sided Wear',
                value: 'Steer Axle One Sided Wear',
                imagelink: $A.get('$Resource.ETT_ETT_One_Sided_Wear'),
                tab: '1'
            },
            {
              inputFields:inputFields07,
                options: options,
                label: 'Diagonal Wear',
                value: 'Diagonal Wear',
                imagelink: $A.get('$Resource.ETT_Crownarea_Diagonalwear'),
                tab: '1'
            },
           {
              inputFields:inputFields08,
                options: options,
                label: 'Eccentric/Out-Of-Round Wear',
                value: 'Eccentric/Out-Of-Round Wear',
                imagelink: $A.get('$Resource.ETT_Crownarea_Eccentric'),
                tab: '1'
            },{
              inputFields:inputFields09,
                options: options,
                label: 'Steer Axle Overall Fast Wear',
                value: 'Steer Axle Overall Fast Wear',
                imagelink: $A.get('$Resource.ETT_Overallfast'),
                tab: '1'
            },
            {
              inputFields:inputFields010,
                options: options,
                label: 'Rib Depression/Punch Wear',
                value: 'Rib Depression/Punch Wear',
                imagelink: $A.get('$Resource.ETT_CrownRib'),
                tab: '1'
            },
            {
              inputFields:inputFields011,
                options: options,
                label: 'Erratic Depression Wear',
                value: 'Erratic Depression Wear',
                imagelink: $A.get('$Resource.ETT_crownerratic'),
                tab: '1'
            },
            {
              inputFields:inputFields012,
                options: options,
                label: 'Drive Axle Shoulder Step/Chamfer Wear',
                value: 'Drive Axle Shoulder Step/Chamfer Wear',
                imagelink: $A.get('$Resource.ETT_CrownDriveShoulder'),
                tab: '2'
            },{
              inputFields:inputFields013,
                options: options,
                label: 'Heel/Toe Wear',
                value: 'Heel/Toe Wear',
                imagelink: $A.get('$Resource.ETT_CrownHeel'),
                tab: '2'
            },
           
            {
              inputFields:inputFields014,
                options: options,
                label: 'Alternate Lug Wear',
                value: 'Alternate Lug Wear',
                imagelink: $A.get('$Resource.ETT_Alternatelugwear'),
                tab: '2'
            },{
              inputFields:inputFields015,
                options: options,
                label: 'Break Skid/Flat Spot Wear',
                value: 'Break Skid/Flat Spot Wear',
                imagelink: $A.get('$Resource.ETT_CrownBreakskid'),
                tab: '2'
            },{
              inputFields:inputFields016,
                options: options,
                label: 'Drive Axle Overall Fast Wear',
                value: 'Drive Axle Overall Fast Wear',
                imagelink: $A.get('$Resource.ETT_Driveaxiloverall'),
                tab: '2'
            },
            /*{ 
               inputFields:inputFields1,
                options: options,
                label: 'Break Skid Flat Spot Wear',
                value: 'Break Skid Flat Spot Wear',
                imagelink: $A.get('$Resource.ETT_CrownBreakskid'),
                tab: '2'
                
            },*/
            { 
               inputFields:inputFields111,
                options: options,
                label: 'Break Skid Flat Spot Wear',
                value: 'Break Skid Flat Spot Wear',
                imagelink: $A.get('$Resource.ETT_TrailerBreakspot'),
                tab: '3'
                
            },
            
            {
                inputFields:inputFields2,
                options: options,
                label: 'Diagonal Wear',
                value: 'Diagonal Wear',
                imagelink: $A.get('$Resource.ETT_trailerdiagonal'),
                tab: '3'
            },
            {
                inputFields:inputFields3,
                options: options,
                label: 'Multiple Flat Spotting Wire',
                value: 'Multiple Flat Spotting Wire',
                imagelink: $A.get('$Resource.ETT_Bead_Deformation'),
                tab: '2'
            },
            {
                inputFields:inputFields333,
                options: options,
                label: 'Multiple Flat Spotting Wire',
                value: 'Multiple Flat Spotting Wire',
                imagelink: $A.get('$Resource.ETT_Multiple'),
                tab: '3'
            },
            {
                inputFields:inputFields4,
                options: options,
                label: 'Rapid Shoulder Wear – One Shoulder',
                value: 'Rapid Shoulder Wear – One Shoulder',
                imagelink: $A.get('$Resource.ETT_Burned_Beads'),
                tab: '1'
                
            },
            {
                inputFields:inputFields44,
                options: options,
                label: 'Rapid Shoulder Wear – One Shoulder',
                value: 'Rapid Shoulder Wear – One Shoulder',
                imagelink: $A.get('$Resource.ETT_Burned_Beads'),
                tab: '2'
                
            },
             {
                inputFields:inputFields444,
                options: options,
                label: 'Rapid Shoulder Wear – One Shoulder',
                value: 'Rapid Shoulder Wear – One Shoulder',
                imagelink: $A.get('$Resource.ETT_rapidoneshoulder'),
                tab: '3'
                
            },
            {
                inputFields:inputFields5,
                options: options,
                label: 'Shoulder Scrubbing/Scuffing Wear',
                value: 'Shoulder Scrubbing/Scuffing Wear',
                imagelink: $A.get('$Resource.ETT_ShoulderScrubbing'),
                tab: '3'
            },
           {
                inputFields:inputFields6,
                options: options,
                label: 'Rapid Shoulder Wear – Both Shoulder',
                value: 'Rapid Shoulder Wear – Both Shoulder',
                imagelink: $A.get('$Resource.ETT_Petro_Lubricant_Damage'),
                 tab: '1'
            },
            {
                inputFields:inputFields66,
                options: options,
                label: 'Rapid Shoulder Wear – Both Shoulder',
                value: 'Rapid Shoulder Wear – Both Shoulder',
                imagelink: $A.get('$Resource.ETT_Petro_Lubricant_Damage'),
                tab: '2'
            }, 
             {
                inputFields:inputFields666,
                options: options,
                label: 'Rapid Shoulder Wear – Both Shoulder',
                value: 'Rapid Shoulder Wear – Both Shoulder',
                imagelink: $A.get('$Resource.ETT_Rapidbothshoulder'),
                tab: '3'
            },
            {
                inputFields:inputFields7,
                options: options,
                label: 'Erratic Depression Wear',
                value: 'Erratic Depression Wear',
                imagelink: $A.get('$Resource.ETT_ErraticDepression'),
                tab: '3'
            },{
                inputFields:inputFields8,
                options: options,
                label: 'Trailer Axle One Sided Wear',
                value: 'Trailer Axle One Sided Wear',
                imagelink: $A.get('$Resource.ETT_TrailerAxleOneSided'),
                tab: '3'
            },{
            inputFields:inputFields9,
                options: options,
                label: 'Erosion/River/Channel Wear',
                value: 'Erosion/River/Channel Wear',
                imagelink: $A.get('$Resource.ETT_TrailerRiverChannel'),
                tab: '3'
            },
           {
                inputFields:inputFields10,
                options: options,
                label: 'Rib Depression/Punch Wear',
                value: 'Rib Depression/Punch Wear',
                imagelink: $A.get('$Resource.ETT_TextileRib'),
                tab: '3'
            }, {
                inputFields: inputFields11,
                options: options,
                label: "Penetrations and Road Hazards",
                value: "None",
                imagelink: $A.get("$Resource.ETT_Crown_PenetrationsAndRoadHazards")
            },
          {
              inputFields: inputFields12,
              options: options,
              label: "Vehicle Damage",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_VehicleDamage")
          },
          {
              inputFields: inputFields13,
              options: options,
              label: "Forklift Damage/Cuts and Snags",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_ForkLiftDamageCutsAndSnags")
          },
          {
              inputFields: inputFields14,
              options: options,
              label: "Belt lift/Separation",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_BeltLiftSeperation")
          },
          {
              inputFields: inputFields15,
              options: options,
              label: "Tread Lift/Separation",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_ThreadLiftSeparation")
          },
          {
              inputFields: inputFields16,
              options: options,
              label: "Break Skid Damage",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_BrakeSkidDamage")
          },
          {
              inputFields: inputFields17,
              options: options,
              label: "Tread/Chunking",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_TreadChunking")
          },
          {
              inputFields: inputFields18,
              options: options,
              label: "Lug Base Cracking",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_LugBaseCracking")
          },
          {
              inputFields: inputFields19,
              options: options,
              label: "Wild Wire",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_WildWire")
          },
          {
              inputFields: inputFields20,
              options: options,
              label: "Impact Break",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_ImpactBreaks")
          },
          {
              inputFields: inputFields21,
              options: options,
              label: "Chipping/Flaking/Chunking Tread",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_ChippingFlakingChunkingTread")
          },
          {
              inputFields: inputFields22,
              options: options,
              label: "Stone Drilling",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_StoneDrilling")
          },
          {
              inputFields: inputFields23,
              options: options,
              label: "Regrooving Damage",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_RegroovingDamage")
          },
          {
              inputFields: inputFields24,
              options: options,
              label: "Dynamometer Type Damage",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_DynamometerDamage")
          },
          {
              inputFields: inputFields25,
              options: options,
              label: "Chemical Damage",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_ChemicalDamage")
          },
          {
              inputFields: inputFields26,
              options: options,
              label: "Excessive Wear",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_ExcessiveWear")
          },
          {
              inputFields: inputFields27,
              options: options,
              label: "Rib Tearing",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_RibTearing")
          },
          {
              inputFields: inputFields28,
              options: options,
              label: "Defense Groove Tearing",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_DefenseGrooveTearing")
          },
          {
              inputFields: inputFields29,
              options: options,
              label: "Groove Cracking",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_GrooveCracking")
          },
          {
              inputFields: inputFields30,
              options: options,
              label: "Spin Damage",
              value: "None",
              imagelink: $A.get("$Resource.ETT_Crown_SpinDamage")
          }
      ];
        var status = [
            /*{
                class: "optionClass",
                label: "-None-",
                value: ""
            },*/
            {
                class: "optionClass",
                label: "Yes",
                value: "Yes"
            },
            {
                class: "optionClass",
                label: "No",
                value: "No"
            }
        ];
        var CutsNTC = [
            {
                class: "optionClass",
                label: "Cuts (0 to 10mm)",
                value: "Cuts (0 to 10mm)",
                selectedvalue: 1
            },
            {
                class: "optionClass",
                label: "Cuts (11 to 25mm)",
                value: "Cuts (11 to 25mm)",
                selectedvalue: 1
            },
            {
                class: "optionClass",
                label: "Cuts (26 to 38mm)",
                value: "Cuts (26 to 38mm)",
                selectedvalue: 1
            },
            {
                class: "optionClass",
                label: "Cuts (39 to 50mm)",
                value: "Cuts (39 to 50mm)",
                selectedvalue: 1
            },
            {
                class: "optionClass",
                label: "Cuts (51mm and above)",
                value: "Cuts (51mm and above)",
                selectedvalue: 1
            }
        ];
        var allCrownAreaOptions = {
            goodConditionsOption: status,
            CrownArea: opts,
            CutsNTC: CutsNTC,
            selectedStatus: "",
            checkboxList : checkbox1,
            OptionList: optionlist
        };
        component.set("v.allCrownAreaOptions", allCrownAreaOptions);
    } catch (err) {
        alert(err.message);
    }
  },
    setValueForTyreInterior: function(component) {
        try {
            var options = [{
                class: "optionClass",
                label: "None",
                value: "None"
            },
                           {
                               class: "optionClass",
                               label: "Rejected",
                               value: "Rejected"
                           },
                           {
                               class: "optionClass",
                               label: "Accepted",
                               value: "Accepted"
                           }
                          ];
            var inputFields1 = [
                {
                    label: "Rejection Name",
                    value: "Penetrating Object"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Penetrating_Object_pro")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Penetrating_Object_recom")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields2 = [
                {
                    label: "Rejection Name",
                    value: "Open Inner Liner Splice"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_open_inner_liner_splice_pro")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_open_inner_liner_splice_Recom")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields3 = [
                {
                    label: "Rejection Name",
                    value: "Inner Liner Bubbles, Blisters and Separations"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Inner_Liner_Bubbles_Blisters_pro")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Inner_Liner_Bubbles_Blisters_recom")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields4 = [
                {
                    label: "Rejection Name",
                    value: "Inner Liner Cracking"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Inner_Liner_Cracking_Pro")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Inner_Liner_Cracking_Recom")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
           
            var inputFields5 = [
                {
                    label: "Rejection Name",
                    value: "Pulled/Loose Cords"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Pulled_Loose_Cords_pro")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Pulled_Loose_Cords_recom")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields6 = [
                {
                    label: "Rejection Name",
                    value: "Tearing, Mount/Dismount Damage"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Tearing_Mount_Dismount_Damage_pro")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Tearing_Mount_Dismount_Damage_recom")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields7 = [
                {
                    label: "Rejection Name",
                    value: "Foreign Object Inner Liner Damage In Tubeless Tyre"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Foreign_Object_Inner_Liner_Damage_In_Tubeless_Pro")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Foreign_Object_Inner_Liner_Damage_In_Tubeless_reco")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields8 = [
                {
                    label: "Rejection Name",
                    value: "Run Flat"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Tyre_int_runflat_pro")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Tyre_int_runflat_recom")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields9 = [
                {
                    label: "Rejection Name",
                    value: "Pinch Shock"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Pinch_Shock_Pro")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Pinch_Shock_Recom")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields10 = [
                {
                    label: "Rejection Name",
                    value: "Impact Break"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Impact_Break_pro")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Impact_Break_Recom")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Penetrating Object",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Penetrating")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Open Inner Liner Splice",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Openinner")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Inner Liner Bubbles, Blisters and Separations",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_InnerBubble")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Inner Liner Cracking",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Innercrack")
                },
                {
                    inputFields: inputFields5,
                    options: options,
                    label: "Pulled/Loose Cords",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_PulledCords")
                },
                {
                    inputFields: inputFields6,
                    options: options,
                    label: "Tearing, Mount/Dismount Damage",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_tearing")
                },
                {
                    inputFields: inputFields7,
                    options: options,
                    label: "Foreign Object Inner Liner Damage In Tubeless Tyre",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Foriegn")
                },
                {
                    inputFields: inputFields8,
                    options: options,
                    label: "Run Flat",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Runflat")
                },
                {
                    inputFields: inputFields9,
                    options: options,
                    label: "Pinch Shock",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_pinch")
                },
                {
                    inputFields: inputFields10,
                    options: options,
                    label: "Impact Break",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_Impactbr")
                }
            ];
            var status = [
                /*{
                    class: "optionClass",
                    label: "-None-",
                    value: ""
                },*/
                {
                    class: "optionClass",
                    label: "Yes",
                    value: "Yes"
                },
                {
                    class: "optionClass",
                    label: "No",
                    value: "No"
                }
            ];
            var checkbox4 = [
                {
                    label: "Spot",
                    value: false
                },
                {
                    label: "Extended",
                    value: false
                },
                {
                    label: "Not Repairable",
                    value: false
                }
            ];
            var cutoptions= [{
                class: "optionClass",
                label: "0",
                value: "0"
                
            },{
                class: "optionClass",
                label: "1",
                value: "1"
            },
            {
              class: "optionClass",
              label: "2",
              value: "2"
            },
            {
                class: "optionClass",
                label: "3",
                value: "3"
            },
            {
              class: "optionClass",
              label: "4",
              value: "4"
            },
            {
                class: "optionClass",
                label: "5",
                value: "5"
            },
            {
              class: "optionClass",
              label: "6",
              value: "6"
            },
            {
                class: "optionClass",
                label: "7",
                value: "7"
            },
            {
              class: "optionClass",
              label: "8",
              value: "8"
            },
            {
                class: "optionClass",
                label: "9",
                value: "9"
            },
            {
              class: "optionClass",
              label: "10",
              value: "10"
            }                  
           ];
           
            var nailPuncture= [{
                class: "optionClass",
                label: "0",
                value: "0"
                
            },{
                class: "optionClass",
                label: "1",
                value: "1"
            },
            {
              class: "optionClass",
              label: "2",
              value: "2"
            },
            {
                class: "optionClass",
                label: "3",
                value: "3"
            },
            {
              class: "optionClass",
              label: "4",
              value: "4"
            },
            {
                class: "optionClass",
                label: "5",
                value: "5"
            },
            {
              class: "optionClass",
              label: "6",
              value: "6"
            },
            {
                class: "optionClass",
                label: "7",
                value: "7"
            },
            {
              class: "optionClass",
              label: "8",
              value: "8"
            },
            {
                class: "optionClass",
                label: "9",
                value: "9"
            },
            {
              class: "optionClass",
              label: "10",
              value: "10"
            }                  
           ];
            var allTyreInteriorOptions = {
                goodConditionsOption: status,
                TyreInterior: opts,
                selectedStatus: "",
                checkboxList : checkbox4,
                cuts : cutoptions,
                selectedCuts :"",
                nailPun : nailPuncture,
                selectedNailPun : ""
            };
            component.set("v.allTyreInteriorOptions", allTyreInteriorOptions);
        } catch (err) {
            alert(err.message);
        }
    },
    setValueForAnyArea: function(component) {
        try {
            var options = [{
                class: "optionClass",
                label: "None",
                value: ""
            },
                           {
                               class: "optionClass",
                               label: "Rejected",
                               value: "Rejected"
                           },
                           {
                               class: "optionClass",
                               label: "Accepted",
                               value: "Accepted"
                           }
                          ];
            var inputFields1 = [
                {
                    label: "Rejection Name",
                    value: "Run Flat"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Any_Area_Run_Flat_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Any_Area_Run_Flat_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields2 = [
                {
                    label: "Rejection Name",
                    value: "Electrical Discharge"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_Any_Area_Electrical_Damage_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_Any_Area_Electrical_Damage_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Run Flat",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_AA_RunFlat")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Electrical Discharge",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_AA_ElectricalDischarge")
                }
            ];
            var status = [
                /*{
                    class: "optionClass",
                    label: "-None-",
                    value: ""
                },*/
                {
                    class: "optionClass",
                    label: "Yes",
                    value: "Yes"
                },
                {
                    class: "optionClass",
                    label: "No",
                    value: "No"
                }
            ];
            var allAnyAreaOptions = {
                goodConditionsOption: status,
                AnyArea: opts,
                selectedStatus: ""
            };
            component.set("v.allAnyAreaOptions", allAnyAreaOptions);
        } catch (err) {
            alert(err.message);
        }
    },
    setValueForHolesandInjuries: function(component) {
        try {
            var options = [{
                class: "optionClass",
                label: "None",
                value: ""
            },
                           {
                               class: "optionClass",
                               label: "Rejected",
                               value: "Rejected"
                           },
                           {
                               class: "optionClass",
                               label: "Accepted",
                               value: "Accepted"
                           }
                          ];
            var inputFields1 = [
                {
                    label: "Rejection Name",
                    value: "Bad Spot Repair"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCA_Bad_Spot_Repair_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCA_Bad_Spot_Repair_Probable_Recom")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields2 = [
                {
                    label: "Rejection Name",
                    value: "Spot Repair Should be a Section Repair"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCA_SpotRepairShuldBeASectionRepairProbable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCA_SpotRepairShuldBeASectionRepairRecommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields3 = [
                {
                    label: "Rejection Name",
                    value: "Improper Nail Hole Repair"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCA_ImproperNailHoleRepairProbableCause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCA_ImproperNailHoleRepairRecommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields4 = [
                {
                    label: "Rejection Name",
                    value: "Improperly Aligned repair"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCA_ImproperlyAlignedRepairProbableCause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCA_ImproperlyAlignedRepairRecommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields5 = [
                {
                    label: "Rejection Name",
                    value: "Unfilled Nail Hole Repair"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCA_UnfilledNailHoleRepairProbableRecommendations")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCA_UnfilledNailHoleRepair_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields6 = [
                {
                    label: "Rejection Name",
                    value: "Bridged Repair"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCA_Bridged_Repair_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCA_Bridged_Repair_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields7 = [
                {
                    label: "Rejection Name",
                    value: "On the Wheel Repair"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCA_On_The_Wheel_Repair_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCA_On_The_Wheel_Repair_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields8 = [
                {
                    label: "Rejection Name",
                    value: "Bad Bead Repair"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCA_Bad_Bead_Repair_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCA_Bad_Bead_Repair_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields9 = [
                {
                    label: "Rejection Name",
                    value: "Failed Repair – Injury Not Removed"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCA_Failed_Repair_Injury_Not_Repaired_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCA_Failed_Repair_Injury_Not_Repaired_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields10 = [
                {
                    label: "Rejection Name",
                    value: "Bias Repair in Radial Tyre"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCA_Bias_Repair_In_Radial_Tire_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCA_Bias_Repair_In_Radial_Tire_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Bad Spot Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCA_BadSpotRepair")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Spot Repair Should be a Section Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCA_SpotRepairShouldBeASectionRepair")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Improper Nail Hole Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCA_ImproperNailHoleRepair")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Improperly Aligned repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCA_ImproperlyAlignedRepair")
                },
                {
                    inputFields: inputFields5,
                    options: options,
                    label: "Unfilled Nail Hole Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCA_UnfilledNailHoleRepair")
                },
                {
                    inputFields: inputFields6,
                    options: options,
                    label: "Bridged Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCA_BridgedRepair")
                },
                {
                    inputFields: inputFields7,
                    options: options,
                    label: "On the Wheel Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCA_OnTheWheelRepair")
                },
                {
                    inputFields: inputFields8,
                    options: options,
                    label: "Bad Bead Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCA_BadBeadRepair")
                },
                {
                    inputFields: inputFields9,
                    options: options,
                    label: "Failed Repair – Injury Not Removed",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCA_FailedRepairInjuryNotRemoved")
                },
                {
                    inputFields: inputFields10,
                    options: options,
                    label: "Bias Repair in Radial Tyre",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCA_BiasRepairInRadialTyre")
                }
            ];
            var status = [
                /*{
                    class: "optionClass",
                    label: "-None-",
                    value: ""
                },*/
                {
                    class: "optionClass",
                    label: "Yes",
                    value: "Yes"
                },
                {
                    class: "optionClass",
                    label: "No",
                    value: "No"
                }
            ];
            var allHolesandInjuriesOptions = {
                goodConditionsOption: status,
                HolesandInjuries: opts,
                selectedStatus: ""
            };
            component.set("v.allHolesandInjuriesOptions", allHolesandInjuriesOptions);
        } catch (err) {
            alert(err.message);
        }
    },
    setValueForMissingLooseTread: function(component) {
        try {
            var options = [{
                class: "optionClass",
                label: "None",
                value: ""
            },
                           {
                               class: "optionClass",
                               label: "Rejected",
                               value: "Rejected"
                           },
                           {
                               class: "optionClass",
                               label: "Accepted",
                               value: "Accepted"
                           }
                          ];
            var inputFields1 = [
                {
                    label: "Rejection Name",
                    value: "Bond Line Porosity"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCB_Bond_Line_Porosity_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCB_Bond_Line_Porosity_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields2 = [
                {
                    label: "Rejection Name",
                    value: "Tread Separation"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCB_Tread_Separation_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCB_Tread_Separation_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields3 = [
                {
                    label: "Rejection Name",
                    value: "Tread Chunking at Splice"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCB_Tread_Chunking_At_Splice_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCB_Tread_Chunking_At_Splice_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields4 = [
                {
                    label: "Rejection Name",
                    value: "Tread Separation – Repair Related"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCB_Tread_Separation_Repair_Related_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCB_Tread_Separation_Repair_Related_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields5 = [
                {
                    label: "Rejection Name",
                    value: "Belt Separation Repair Related"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCB_Belt_Separation_Repair_Related_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCB_Belt_Separation_Repair_Related_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields6 = [
                {
                    label: "Rejection Name",
                    value: "Missed Puncture"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCB_Missed_Puncture_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCB_Missed_Puncture_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields7 = [
                {
                    label: "Rejection Name",
                    value: "Tread Edge Lifting"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCB_Tread_Edge_Lifting_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCB_Tread_Edge_Lifting_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Bond Line Porosity",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCB_BondLinePorosity")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Tread Separation",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCB_TreadSeparation")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Tread Chunking at Splice",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCB_TreadChunkingAtSplice")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Tread Separation – Repair Related",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCB_TreadSeparationRepairRelated")
                },
                {
                    inputFields: inputFields5,
                    options: options,
                    label: "Belt Separation Repair Related",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCB_BeltSeparationRepairRelated")
                },
                {
                    inputFields: inputFields6,
                    options: options,
                    label: "Missed Puncture",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCB_MissedPuncture")
                },
                {
                    inputFields: inputFields7,
                    options: options,
                    label: "Tread Edge Lifting",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCB_TreadEdgeLifting")
                }
            ];
            var status = [
                /*{
                    class: "optionClass",
                    label: "-None-",
                    value: ""
                },*/
                {
                    class: "optionClass",
                    label: "Yes",
                    value: "Yes"
                },
                {
                    class: "optionClass",
                    label: "No",
                    value: "No"
                }
            ];
            var allMissingLooseTreadOptions = {
                goodConditionsOption: status,
                MissingLooseTread: opts,
                selectedStatus: ""
            };
            component.set(
                "v.allMissingLooseTreadOptions",
                allMissingLooseTreadOptions
            );
        } catch (err) {
            alert(err.message);
        }
    },
    setValueForCracks: function(component) {
        try {
            var options = [{
                class: "optionClass",
                label: "None",
                value: ""
            },
                           {
                               class: "optionClass",
                               label: "Rejected",
                               value: "Rejected"
                           },
                           {
                               class: "optionClass",
                               label: "Accepted",
                               value: "Accepted"
                           }
                          ];
            var inputFields1 = [
                {
                    label: "Rejection Name",
                    value: "Failed Inner Liner Repair"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCC_Failed_Inner_Liner_Repair_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCC_Failed_Inner_Liner_Repair_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields2 = [
                {
                    label: "Rejection Name",
                    value: "Lug Base Cracking/Tearing"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCC_Lug_Base_Cracking_tearing_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCC_Lug_Base_Cracking_tearing_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields3 = [
                {
                    label: "Rejection Name",
                    value: "Improper Tread Width"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCC_Improper_Tread_Width_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCC_Improper_Tread_Width_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields4 = [
                {
                    label: "Rejection Name",
                    value: "Open Tread Splice"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCC_Open_Tread_Splice_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCC_Open_Tread_Splice_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Failed Inner Liner Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCC_FailedInnerLinerRepair")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Lug Base Cracking/Tearing",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCC_LugBaseCrackingTearing")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Improper Tread Width",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCC_ImproperTreadWidth")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Open Tread Splice",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCC_OpenTreadSplice")
                }
            ];
            var status = [
                /*{
                    class: "optionClass",
                    label: "-None-",
                    value: ""
                },*/
                {
                    class: "optionClass",
                    label: "Yes",
                    value: "Yes"
                },
                {
                    class: "optionClass",
                    label: "No",
                    value: "No"
                }
            ];
            var allCracksOptions = {
                goodConditionsOption: status,
                Cracks: opts,
                selectedStatus: ""
            };
            component.set("v.allCracksOptions", allCracksOptions);
        } catch (err) {
            alert(err.message);
        }
    },
    setValueForBulgesDepressions: function(component) {
        try {
            var options = [{
                class: "optionClass",
                label: "None",
                value: ""
            },
                           {
                               class: "optionClass",
                               label: "Rejected",
                               value: "Rejected"
                           },
                           {
                               class: "optionClass",
                               label: "Accepted",
                               value: "Accepted"
                           }
                          ];
            var inputFields1 = [
                {
                    label: "Rejection Name",
                    value: "Skiving Failure"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCD_Skive_Failure_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCD_Skive_Failure_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields2 = [
                {
                    label: "Rejection Name",
                    value: "Repair Related Bulge"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCD_Repair_Related_Bulge_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCD_Repair_Related_Bulge_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields3 = [
                {
                    label: "Rejection Name",
                    value: "Buckled Tread"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCD_Buckled_Tread_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCD_Buckled_Tread_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Skiving Failure",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCD_SkiveFailure")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Repair Related Bulge",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCD_RepairRelatedBulge")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Buckled Tread",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCD_BuckledTread")
                }
            ];
            var status = [
                /*{
                    class: "optionClass",
                    label: "-None-",
                    value: ""
                },*/
                {
                    class: "optionClass",
                    label: "Yes",
                    value: "Yes"
                },
                {
                    class: "optionClass",
                    label: "No",
                    value: "No"
                }
            ];
            var allBulgesDepressionsOptions = {
                goodConditionsOption: status,
                BulgesDepressions: opts,
                selectedStatus: ""
            };
            component.set(
                "v.allBulgesDepressionsOptions",
                allBulgesDepressionsOptions
            );
        } catch (err) {
            alert(err.message);
        }
    },
    setValueForMiscellaneous: function(component) {
        try {
            var options = [{
                class: "optionClass",
                label: "None",
                value: ""
            },
                           {
                               class: "optionClass",
                               label: "Rejected",
                               value: "Rejected"
                           },
                           {
                               class: "optionClass",
                               label: "Accepted",
                               value: "Accepted"
                           }
                          ];
            var inputFields1 = [
                {
                    label: "Rejection Name",
                    value: "Delamination"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCE_Delamination_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCE_Delamination_Recomendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields2 = [
                {
                    label: "Rejection Name",
                    value: "Tread Surface Porosity"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCE_Tread_Surface_Porosity_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCE_Tread_Surface_Porosity_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields3 = [
                {
                    label: "Rejection Name",
                    value: "Wing Lift"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCE_Wing_Lift_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCE_Wing_Lift_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var inputFields4 = [
                {
                    label: "Rejection Name",
                    value: "Failed Repair from Under Inflation"
                },
                {
                    label: "Cause Of Rejection",
                    value: $A.get("$Label.c.ETT_RCE_Failed_Repair_From_Underinflation_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.ETT_RCE_Failed_Repair_From_Underinflation_Recommendations")
                },
                {
                    label: "Other",
                    value: ""
                },
                {
                    label: "strFileType",
                    value: ""
                },
                {
                    label: "strFileName",
                    value: ""
                },
                {
                    label: "fileContent",
                    value: ""
                },
                {
                    label: "strRejectionName",
                    value: ""
                },
                {
                    label: "parentId",
                    value: ""
                }
            ];
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Delamination",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCE_Delamination")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Tread Surface Porosity",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCE_TreadSurfacePorosity")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Wing Lift",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCE_WingLIft")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Failed Repair from Under Inflation",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_RCE_FailedReapirFromUnderInflation")
                }
            ];
            var status = [
                /*{
                    class: "optionClass",
                    label: "-None-",
                    value: ""
                },*/
                {
                    class: "optionClass",
                    label: "Yes",
                    value: "Yes"
                },
                {
                    class: "optionClass",
                    label: "No",
                    value: "No"
                }
            ];
            var allMiscellaneousOptions = {
                goodConditionsOption: status,
                Miscellaneous: opts,
                selectedStatus: ""
            };
            component.set("v.allMiscellaneousOptions", allMiscellaneousOptions);
        } catch (err) {
            alert(err.message);
        }
    },
    
    save: function(component) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        
        if (file.size > this.MAX_FILE_SIZE) {
            alert(
                "File size cannot exceed " +
                this.MAX_FILE_SIZE +
                " bytes.\n" +
                "Selected file size: " +
                file.size
            );
            return;
        }
        
        var fr = new FileReader();
        
        var self = this;
        fr.onload = function() {
            var fileContents = fr.result;
            var base64Mark = "base64,";
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            
            fileContents = fileContents.substring(dataStart);
            
            self.upload(component, file, fileContents);
        };
        
        fr.readAsDataURL(file);
    },
    
    upload: function(component, file, fileContents) {
        var action = component.get("c.saveTheFiles");
        
        action.setParams({
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: fileContents,
            contentType: file.type
        });
        
        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            console.log(attachId);
        });
        
        /*  $A.run(function() {
            $A.enqueueAction(action); 
        });*/
  }
});