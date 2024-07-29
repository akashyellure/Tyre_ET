({
    doInit: function(component, event, helper) {
         var checkboxgroup = [{
                'label': 'Poking Screwdriver',
                'value': 'Poking Screwdriver'
            },
            {
                'label': 'Tyre Tapping Tool',
                'value': 'Tyre Tapping Tool'
            },
            {
                'label': 'Chalk / Crayon - Yellow',
                'value': 'Chalk / Crayon - Yellow'
            },
            {
                'label': 'Nail Remover',
                'value': 'Nail Remover'
            },
            {
                'label': 'Cutting Player',
                'value': 'Cutting Player'
            },
            {
                'label': 'Spiral Cement Tool',
                'value': 'Spiral Cement Tool'
            },
            {
                'label': 'Handheld drop light',
                'value': 'Handheld drop light'
            },
            {
                'label': 'Knife',
                'value': 'Knife'
            },
            {
                'label': 'Staple gun',
                'value': 'Staple gun'
            },
            {
                'label': 'Industrial Vacuum Cleaner',
                'value': 'Industrial Vacuum Cleaner'
            },
        ];
        var emptyarr = [];
        var mainGroup = [
            {
            'label' : 'Supporting Tools Available',
            'value': '',
                'subitem': checkboxgroup
        },
            {
            'label' : 'Electrical Prob in working condition',
            'value': '',
              'subitem': emptyarr
        },
        {
            'label' : 'Tyre Spreader in Working Condition',
            'value': '',
              'subitem': emptyarr
        },
            {
            'label' : 'Spreader Light Condition',
            'value': '',
              'subitem': emptyarr
        },
            {
            'label' : 'Tyre Lift In Working Condition',
            'value': '',
              'subitem': emptyarr
        }];
       
        component.set('v.options', mainGroup);
        
       
    },
    checkAllcheckBoxChecked: function(component, event, helper) {
        var allSelectedOptions = component.get('v.value');
        var options = component.get('v.options');
        var WearRequiredPPT = component.get('v.WearRequiredPPT');
        if (options.length == allSelectedOptions.length && WearRequiredPPT) {
            component.set('v.isJobDisabled', false);
        } else {
            component.set('v.isJobDisabled', true);
        }
    },
   	onCheck: function(component, event, helper) {
        let targetElement  = event.target;
        let index = event.target.value;
        var options = component.get('v.options');
        if(index != 'WearRequiredPPT'){
            options[index].value = event.target.checked;
        }else{
             component.set('v.WearRequiredPPT', event.target.checked);
        }
        let flag = true;
        for(let ind in options){
            if(options[ind].value == false){
                flag = false;
                break;
            }
        }
        var WearRequiredPPT = component.get('v.WearRequiredPPT');
        if (flag && WearRequiredPPT) {
            component.set('v.isJobDisabled', false);
        } else {
            component.set('v.isJobDisabled', true);
        }
    },
    startJob: function(component, event, helper) {
        component.set('v.isTechnicianInspectionOpen', true);
        let currentTime  = $A.localizationService.formatDate(new Date(), "yyyy-MM-ddTHH:mm:ss");
        component.set("v.currentTime",currentTime );
        
        component.find("inspRec").submit();
    },
    closePopUp: function(component, event, helper) {
        component.set('v.isTechnicianInspectionOpen', false);
    },
    handleCheckAllBox: function(component, event, helper) {
        component.set('v.isJobDisabled',!event.target.checked);
        component.set('v.allcheckboxes',event.target.checked);
    }
    
})