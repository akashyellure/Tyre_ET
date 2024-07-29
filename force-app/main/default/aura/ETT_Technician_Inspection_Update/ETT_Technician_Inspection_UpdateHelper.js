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
            
            //'strRecordTypeName':'0123M0000008iGUQAY',
            
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
            
            var allBeadAreaOptions = {
                goodConditionsOption: status,
                BeadArea: opts,
                selectedStatus: ""
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
                    value: "Weathering"
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
                    label: "Weathering",
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
            ///
            var inputFields01 = [{
                label: 'Rejection Name',
                value: 'Shoulder Step/Chamfer Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields02 = [{
                label: 'Rejection Name',
                value: 'Full Shoulder Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields03 = [{
                label: 'Rejection Name',
                value: 'Feather Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields04 = [{
                label: 'Rejection Name',
                value: 'Erosion/River/Channel Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields05 = [{
                label: 'Rejection Name',
                value: 'Cupping/Scallop Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields06 = [{
                label: 'Rejection Name',
                value: 'One Sided Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields07 = [{
                label: 'Rejection Name',
                value: 'Diagonal Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields08 = [{
                label: 'Rejection Name',
                value: 'Eccentric/Out-Of-Round Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields09 = [{
                label: 'Rejection Name',
                value: 'Overall Fast Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields010 = [{
                label: 'Rejection Name',
                value: 'Rib Depression/Punch Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields011 = [{
                label: 'Rejection Name',
                value: 'Erratic Depression Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields012 = [{
                label: 'Rejection Name',
                value: 'Shoulder Step/Chamfer Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields013 = [{
                label: 'Rejection Name',
                value: 'Heel/Toe Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields014 = [{
                label: 'Rejection Name',
                value: 'Alternate Lug Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields015 = [{
                label: 'Rejection Name',
                value: 'Break Skid/Flat Spot Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields016 = [{
                label: 'Rejection Name',
                value: 'Overall Fast Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            //
             var inputFields1 = [{
                label: 'Rejection Name',
                value: 'Break Skid Flat Spot Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Spread_Damaged_Cord_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Spread_Damaged_Cord_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields2 = [{
                label: 'Rejection Name,',
                value: 'Diagonal Wear'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields3 = [{
                label: 'Rejection Name,',
                value: 'Multiple Flat Spotting Wire'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_SWA_Sidewall_Seperation_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Sidewall_Seperation_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields4 = [{
                label: 'Rejection Name,',
                value: 'Rapid Shoulder Wear – One Shoulder'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_SWA_Chain_Damage_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.SWA_Chain_Damage_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields5 = [{
                label: 'Rejection Name,',
                value: 'Shoulder Scrubbing/Scuffing Wear'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_SWA_Vehicle_Equipment_Damage_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_SWA_Vehicle_Equipment_Damage_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields6 = [{
                label: 'Rejection Name,',
                value: 'Rapid Shoulder Wear – Both Shoulder'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_SWA_Damaged_Induced_Sidewall_Separation_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_SWA_Damaged_Induced_Sidewall_Separation_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields7 = [{
                label: 'Rejection Name,',
                value: 'Erratic Depression Wear'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_SWA_Sidewall_Abrasion_Scuff_Damage_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_SWA_Sidewall_Abrasion_Scuff_Damage_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields8 = [{
                label: 'Rejection Name,',
                value: 'One Sided Wear'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_SWA_Weathering_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_SWA_Weathering_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            
            var inputFields9 = [{
                label: 'Rejection Name',
                value: 'Erosion/River/Channel Wear'
            }, {
                label: 'Cause Of Rejection',
                value : $A.get("$Label.c.ETT_SWA_Impact_Break_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_SWA_Impact_Break_Recommendations")
            },{
                label: "Other",
                value: ""
            }];
            var inputFields10 = [{
                label: 'Rejection Name,',
                value: 'Rib Depression/Punch Wear'
            }, {
                label: 'Cause Of Rejection',
                value :$A.get("$Label.c.ETT_SWA_Branding_Damage_Probable_Cause"),
            }, {
                label: 'Recommendation',
                value: $A.get("$Label.c.ETT_SWA_Branding_Damage_Recommendations")
            },{
                label: "Other",
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
        var opts = [
            {
              inputFields:inputFields01,
                options: options,
                label: 'Shoulder Step/Chamfer Wear',
                value: 'Shoulder Step/Chamfer Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields02,
                options: options,
                label: 'Full Shoulder Wear ',
                value: 'Full Shoulder Wear ',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields03,
                options: options,
                label: 'Feather Wear',
                value: 'Feather Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields04,
                options: options,
                label: 'Erosion/River/Channel Wear',
                value: 'Erosion/River/Channel Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields05,
                options: options,
                label: 'Cupping/Scallop Wear',
                value: 'Cupping/Scallop Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields06,
                options: options,
                label: 'One Sided Wear',
                value: 'One Sided Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields07,
                options: options,
                label: 'Diagonal Wear',
                value: 'Diagonal Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields08,
                options: options,
                label: 'Eccentric/Out-Of-Round Wear',
                value: 'Eccentric/Out-Of-Round Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields09,
                options: options,
                label: 'Overall Fast Wear',
                value: 'Overall Fast Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields010,
                options: options,
                label: 'Rib Depression/Punch Wear',
                value: 'Rib Depression/Punch Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields011,
                options: options,
                label: 'Erratic Depression Wear',
                value: 'Erratic Depression Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },
            {
              inputFields:inputFields012,
                options: options,
                label: 'Shoulder Step/Chamfer Wear',
                value: 'Shoulder Step/Chamfer Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields013,
                options: options,
                label: 'Heel/Toe Wear',
                value: 'Heel/Toe Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields014,
                options: options,
                label: 'Alternate Lug Wear',
                value: 'Alternate Lug Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields015,
                options: options,
                label: 'Break Skid/Flat Spot Wear',
                value: 'Break Skid/Flat Spot Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
              inputFields:inputFields016,
                options: options,
                label: 'Overall Fast Wear',
                value: 'Overall Fast Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },
            
            
            
            
            { 
               inputFields:inputFields1,
                options: options,
                label: 'Break Skid Flat Spot Wear',
                value: 'Break Skid Flat Spot Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
                inputFields:inputFields2,
                options: options,
                label: 'Diagonal Wear',
                value: 'Diagonal Wear',
                imagelink: $A.get('$Resource.ETT_Kinked_Distorted_Beads')
            },{
                inputFields:inputFields3,
                options: options,
                label: 'Multiple Flat Spotting Wire',
                value: 'Multiple Flat Spotting Wire',
                imagelink: $A.get('$Resource.ETT_Bead_Deformation')
            },{
                inputFields:inputFields4,
                options: options,
                label: 'Rapid Shoulder Wear – One Shoulder',
                value: 'Rapid Shoulder Wear – One Shoulder',
                imagelink: $A.get('$Resource.ETT_Burned_Beads')
            },{
                inputFields:inputFields5,
                options: options,
                label: 'Shoulder Scrubbing/Scuffing Wear',
                value: 'Shoulder Scrubbing/Scuffing Wear',
                imagelink: $A.get('$Resource.ETT_Reinforce_Chafer_Separation')
            },{
                inputFields:inputFields6,
                options: options,
                label: 'Rapid Shoulder Wear – Both Shoulder',
                value: 'Rapid Shoulder Wear – Both Shoulder',
                imagelink: $A.get('$Resource.ETT_Petro_Lubricant_Damage')
            },{
                inputFields:inputFields7,
                options: options,
                label: 'Erratic Depression Wear',
                value: 'Erratic Depression Wear',
                imagelink: $A.get('$Resource.ETT_Bead_Damage_from_Curbing')
            },{
                inputFields:inputFields8,
                options: options,
                label: 'One Sided Wear',
                value: 'One Sided Wear',
                imagelink: $A.get('$Resource.ETT_Bead_Area_Flow_Crack')
            },{
            inputFields:inputFields9,
                options: options,
                label: 'Erosion/River/Channel Wear',
                value: 'Erosion/River/Channel Wear',
                imagelink: $A.get('$Resource.ETT_Torn_Bead')
            },{
                inputFields:inputFields10,
                options: options,
                label: 'Rib Depression/Punch Wear',
                value: 'Rib Depression/Punch Wear',
                imagelink: $A.get('$Resource.ETT_Kinked_Distorted_Beads')
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
            selectedStatus: ""
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
                    value: "Penetrating Object"
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
                    value: "Open Inner Liner Splice"
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Open Inner Liner Splice",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Inner Liner Bubbles, Blisters and Separations",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Inner Liner Cracking",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields5,
                    options: options,
                    label: "Pulled/Loose Cords",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields6,
                    options: options,
                    label: "Tearing, Mount/Dismount Damage",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields7,
                    options: options,
                    label: "Foreign Object Inner Liner Damage In Tubeless Tyre",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields8,
                    options: options,
                    label: "Run Flat",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields9,
                    options: options,
                    label: "Pinch Shock",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields10,
                    options: options,
                    label: "Impact Break",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
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
            var allTyreInteriorOptions = {
                goodConditionsOption: status,
                TyreInterior: opts,
                selectedStatus: ""
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
                    value: "Electrical Discharge"
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
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Run Flat",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Electrical Discharge",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
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
                    value: "Spot Repair Should be a Section Repair"
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
            var inputFields3 = [
                {
                    label: "Rejection Name",
                    value: "Improper Nail Hole Repair"
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
            var inputFields4 = [
                {
                    label: "Rejection Name",
                    value: "Improperly Aligned repair"
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
            var inputFields5 = [
                {
                    label: "Rejection Name",
                    value: "Unfilled Nail Hole Repair"
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
            var inputFields6 = [
                {
                    label: "Rejection Name",
                    value: "Bridged Repair"
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
            var inputFields7 = [
                {
                    label: "Rejection Name",
                    value: "On the Wheel Repair"
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
            var inputFields8 = [
                {
                    label: "Rejection Name",
                    value: "Bad Bead Repair"
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
            var inputFields9 = [
                {
                    label: "Rejection Name",
                    value: "Failed Repair – Injury Not Removed"
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
            var inputFields10 = [
                {
                    label: "Rejection Name",
                    value: "Bias Repair in Radial Tyre"
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
            var opts = [
                {
                    inputFields: inputFields1,
                    options: options,
                    label: "Bad Spot Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Spot Repair Should be a Section Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Improper Nail Hole Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Improperly Aligned repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields5,
                    options: options,
                    label: "Unfilled Nail Hole Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields6,
                    options: options,
                    label: "Bridged Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields7,
                    options: options,
                    label: "On the Wheel Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields8,
                    options: options,
                    label: "Bad Bead Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields9,
                    options: options,
                    label: "Failed Repair – Injury Not Removed",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields10,
                    options: options,
                    label: "Bias Repair in Radial Tyre",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
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
                    value: "Tread Separation"
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    value: $A.get("$Label.c.ETT_SWA_Cust_and_Snags_Probable_Cause")
                },
                {
                    label: "Recommendation",
                    value: $A.get("$Label.c.SWA_Cust_and_Snags_Recommendations")
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
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Tread Separation",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Tread Chunking at Splice",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_RadialSplit")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Tread Separation – Repair Related",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields5,
                    options: options,
                    label: "Belt Separation Repair Related",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields6,
                    options: options,
                    label: "Missed Puncture",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields7,
                    options: options,
                    label: "Tread Edge Lifting",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
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
                    value: "Lug Base Cracking/Tearing"
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
            var inputFields4 = [
                {
                    label: "Rejection Name",
                    value: "Open Tread Splice"
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
                    label: "Failed Inner Liner Repair",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Lug Base Cracking/Tearing",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Improper Tread Width",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_RadialSplit")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Open Tread Splice",
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
                    value: "Repair Related Bulge"
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
                    label: "Skiving Failure",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Repair Related Bulge",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Buckled Tread",
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
                    value: "Tread Surface Porosity"
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
            var inputFields4 = [
                {
                    label: "Rejection Name",
                    value: "Failed Repair from Under Inflation"
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
                    label: "Delamination",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_SpreadDamagedCord")
                },
                {
                    inputFields: inputFields2,
                    options: options,
                    label: "Tread Surface Porosity",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_CutsandSnags")
                },
                {
                    inputFields: inputFields3,
                    options: options,
                    label: "Wing Lift",
                    value: "None",
                    imagelink: $A.get("$Resource.ETT_SW_RadialSplit")
                },
                {
                    inputFields: inputFields4,
                    options: options,
                    label: "Failed Repair from Under Inflation",
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