@isTest
public class ETT_SOAPMockTestClass implements WebServiceMock {

        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof ETT_PO_Output.OutputParameters_element){
                
                ETT_PO_Output.OutputParameters_element det = new ETT_PO_Output.OutputParameters_element();
                det.PV_OUT_STATUS = 'Y';
                det.PV_OUT_ERRORMESSAGE ='';
                det.PV_OUT_EBS_REF_NO='234324';
                response.put('response_x', det);
            }
            if(request instanceof ETT_MiscIssue_Output.OutputParameters_element){
                
                ETT_MiscIssue_Output.OutputParameters_element det = new ETT_MiscIssue_Output.OutputParameters_element();
                det.PV_OUT_STATUS = 'Y';
                det.PV_OUT_ERRORMESSAGE ='';
                det.PV_OUT_EBS_REF_NO='234324';
                response.put('response_x', det);
            }
                
           
        }
    

}