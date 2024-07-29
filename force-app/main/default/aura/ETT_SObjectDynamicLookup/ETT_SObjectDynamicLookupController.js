({
    getValues : function (component) {
        var record = component.get("v.record");
        var subheading = '';
        for(var i=0; i<component.get("v.subHeadingFieldsAPI").length; i++ ){
            if(record[component.get("v.subHeadingFieldsAPI")[i]]){
                subheading = subheading + record[component.get("v.subHeadingFieldsAPI")[i]] + ' - ';
            }
        }
        subheading = subheading.substring(0,subheading.lastIndexOf('-'));
        console.log('*****subheading*****'+subheading);
        component.set("v.subHeadingFieldValues", subheading);
    },
     
    handleSelect : function (component,event) {
        var chooseEvent = component.getEvent("lookupSelect");
        chooseEvent.setParams({
            "recordId" : component.get("v.record").Id,
            "recordName":component.get("v.record").Name
        });
        console.log('****chooseEvent****'+chooseEvent);
        chooseEvent.fire();
    }
})