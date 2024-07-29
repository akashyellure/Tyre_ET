({
    toggleLookupList : function (component, ariaexpanded, classadd, classremove) {
        component.find("divLookup").set("v.aria-expanded", true);
        $A.util.addClass(component.find("divLookup"), classadd);
        $A.util.removeClass(component.find("divLookup"), classremove);
    },
     
    searchRecord : function (component, searchText) {
        component.find("searchinput").set("v.isLoading", true);        
        var action = component.get("c.searchRecord");
        action.setParams({
            "objectAPIName": component.get("v.objectAPIName"),
            "fieldAPIName":component.get("v.fieldAPIName"),
            "moreFields":component.get("v.subHeadingFieldsAPI"),
            "searchText":searchText,
            "recordLimit":component.get("v.recordLimit")
        });
         
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue()){
                    component.set("v.matchingRecords", response.getReturnValue());
                    if(response.getReturnValue().length > 0){
                        this.toggleLookupList(component, true, 'slds-is-open', 'slds-combobox-lookup');
                    }
                    component.find("searchinput").set("v.isLoading", false);
                }
            }
        });
        $A.enqueueAction(action);
    }
})