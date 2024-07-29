({
    doInitHelper : function(component) {
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        var value = component.get('v.value');
        var values = component.get('v.values');
		if( !$A.util.isEmpty(value) || !$A.util.isEmpty(values) ) {
            var searchString;
        	var count = 0;
            var multiSelect = component.get('v.multiSelect');
			var options = component.get('v.options');
            options.forEach( function(element, index) {
                if(multiSelect) {
                    if(values.includes(element.value)) {
                        element.selected = true;
                        count++;
                    }  
                } else {
                    if(element.value == value) {
                        searchString = element.label;
                    }
                }
            });
            if(multiSelect)
                component.set('v.searchString', count + ' options selected');
            else
                component.set('v.searchString', searchString);
            component.set('v.options', options);
		}
    },
    
     doInitHelper2 : function( component, event, helper ) {     
     var action = component.get("c.getDetailsOnLoad");
     action.setParams({
                "objObject": 'Fleet_Inspection_Line_Item__c',
                "fld": 'ETT_Bad_Reason_Complaint__c'
            }); 
     var acPromise = this.executeAction(component, action);
  	 acPromise.then(
        $A.getCallback(function(res){
            
            	var opts = [];
            	var result = res.getBadReasonValues;
                for(var key in result){
                    opts.push({label: result[key], value: result[key]});
                }
                component.set('v.options', opts);
                this.doInitHelper(component); 
            	
        }),
        $A.getCallback(function(error){           
            alert('An error occurred getting the values : ' + error.message);
        })
     );         
 },
    
  executeAction: function(cmp, action, callback) {
    return new Promise(function(resolve, reject) {
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                resolve(retVal);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        reject(Error("Error message: " + errors[0].message));
                    }
                }
                else {
                    reject(Error("Unknown error"));
                }
            }
        });
    $A.enqueueAction(action);
    });
},
    filterOptionsHelper : function(component) {
        component.set("v.message", '');
        var searchText = component.get('v.searchString');
		var options = component.get("v.options");
		var minChar = component.get('v.minChar');
		if(searchText.length >= minChar) {
            var flag = true;
			options.forEach( function(element,index) {
                if(element.label.toLowerCase().trim().startsWith(searchText.toLowerCase().trim())) {
					element.isVisible = true;
                    flag = false;
                } else {
					element.isVisible = false;
                }
			});
			component.set("v.options",options);
            if(flag) {
                component.set("v.message", "No results found for '" + searchText + "'");
            }
		}
        $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
	},
    
    selectItemHelper : function(component, event) {
        var options = component.get('v.options');
        var multiSelect = component.get('v.multiSelect');
        var searchString = component.get('v.searchString');
        var values = component.get('v.values') || [];
        var value;
        var count = 0;
        options.forEach( function(element, index) {
            if(element.value === event.currentTarget.id) {
                if(multiSelect) {
                    if(values.includes(element.value)) {
                        values.splice(values.indexOf(element.value), 1);
                    } else {
                        values.push(element.value);
                    }
                    element.selected = element.selected ? false : true;   
                } else {
                    value = element.value;
                    searchString = element.label;
                }
            }
            if(element.selected) {
                count++;
            }
        });
        component.set('v.value', value);
        component.set('v.values', values);
        component.set('v.options', options);
        if(multiSelect)
            component.set('v.searchString', count + ' options selected');
        else
            component.set('v.searchString', searchString);
        if(multiSelect)
            event.preventDefault();
        else
        	$A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
    
    removePillHelper : function(component, event) {
        var value = event.getSource().get('v.name');
        var multiSelect = component.get('v.multiSelect');
        var count = 0;
        var options = component.get("v.options");
        var values = component.get('v.values') || [];
        options.forEach( function(element, index) {
            if(element.value === value) {
                element.selected = false;
                values.splice(values.indexOf(element.value), 1);
            }
            if(element.selected) {
                count++;
            }
        });
        if(multiSelect)
        	component.set('v.searchString', count + ' options selected');
        component.set('v.values', values)
        component.set("v.options", options);
    },
    
    blurEventHelper : function(component, event) {
        var selectedValue = component.get('v.value');
        var multiSelect = component.get('v.multiSelect');
        var previousLabel;
        var count = 0;
        var options = component.get("v.options");
        options.forEach( function(element, index) {
            if(element.value === selectedValue) {
                previousLabel = element.label;
            }
            if(element.selected) {
                count++;
            }
        });
        if(multiSelect)
        	component.set('v.searchString', count + ' options selected');
        else
        	component.set('v.searchString', previousLabel);
        
    	if(multiSelect)
        	$A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    }
})