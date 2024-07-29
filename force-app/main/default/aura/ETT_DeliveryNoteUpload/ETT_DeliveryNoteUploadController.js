({
    doInit : function(component, event, helper) {        
    },
    onFileUploaded:function(component,event,helper){
        var FileNamelist = [];
        console.log('called function');
        var fileSourceType = event.getSource().getLocalId();
        var objWrapper = component.get("v.fileUploadWrapper");
        var files = component.get("v.fileToBeUploaded");
        var contentWrapperArr = [];
        var fileUploadWrapper = component.get("v.fileUploadWrapper");
        
        if (files && files.length > 0) {
            for(var i=0; i < files[0].length; i++){
                var file = files[0][i];
                var reader = new FileReader();
                reader.name = file.name;
                reader.type = file.type;
                FileNamelist.push(reader.name);
                var fileSizeInMB = (file.size / (1024*1024)).toFixed(2);
                
                if(fileSizeInMB > 4 && fileSourceType=='uploadSigneDeliveryNote'){
                    document.getElementById("uploadSigneDeliveryNoteErr").innerHTML = "Error: File size must be 4MB or less than 4MB";
                    return false;
                }else{
                    document.getElementById("uploadSigneDeliveryNoteErr").innerHTML = "";
                }
                
                reader.onloadend = function(e) {
                    var base64Img = e.target.result;
                    var base64result = base64Img.split(',')[1];
                    console.log(e.target.name+'======');
                    fileUploadWrapper.push({
                        'strFileName':e.target.name,
                        'strFileType':e.target.type,
                        'fileSourceType':fileSourceType,
                        'strBase64Data':base64result,
                        'fileContent':e.target.result
                        
                    });
                    contentWrapperArr.push({
                          'strFileName':e.target.name,
                        'strFileType':e.target.type,
                        'fileSourceType':fileSourceType,
                        'strBase64Data':base64result,
                        'fileContent':e.target.result
                    });
                }
                
                function handleEvent(event) {
                    if(contentWrapperArr.length == i){
                        console.log(JSON.stringify(fileUploadWrapper));
                        component.set("v.fileUploadWrapper",fileUploadWrapper);
                        component.set("v.fileNames",FileNamelist);
                        component.set("v.isfileNamesPresent",true);
                        //alert(FileNamelist);
                    }
                }
                
                reader.readAsDataURL(file);
                reader.addEventListener('loadend', handleEvent);
                
            }
            //console.log(files);
            //var file = files[0][0];
            //console.log(file.name);
            //var reader = new FileReader();
            /*reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                objWrapper.push({'strFileName':file.name, 'strBase64Data':content, 'strFileType':file.type});
                component.set("v.fileUploadWrapper",objWrapper);
            }
            reader.readAsDataURL(file);
            */
        }
          else{
              //helper.hide(component,event);
          }
      },
    submit : function(component, event, helper) {
        
        var objWrapper = component.get("v.fileUploadWrapper");
        
        var action = component.get("c.uploadSignedDeliveryNote");
        
        var mapofStageJsonList = {
            filesToUpload: JSON.stringify(objWrapper)
        };
       
        action.setParams({
            mapofStageJsonList: mapofStageJsonList,
            DeliveryAppointmentId: component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    url: "/" + component.get("v.recordId")
                });
                urlEvent.fire();
                
            }else if (state === "ERROR") {
                
                console.log("Error: ");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }
                
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        
        
    },
})