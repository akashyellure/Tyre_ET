//Generated by wsdl2apex

public class ETT_CreateJournalVoucher_Service {
    public class execute_pt {
        public String endpoint_x = 'https://etdevsoa.et.gov.ae:443/soa-infra/services/CommonBusinessServices/CreateJournalVoucher/Client';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x=120000; //30000;
        private String[] ns_map_type_info = new String[]{'http://oracle.com/sca/soapservice/Test/CreateJournalVoucher/Client', 'ETT_CreateJournalVoucher_Service', 'http://www.et.ae', 'ETT_CreateJournalVoucher'};
        public ETT_CreateJournalVoucher.Response_element execute(ETT_CreateJournalVoucher.Journal_Header Journal_Voucher) {
            //setting End point url 
            boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            ET_SOA_Endpoint__mdt md = [SELECT DeveloperName,LiveEndpoint__c,TestEndpoint__c FROM ET_SOA_Endpoint__mdt WHERE DeveloperName='Tyre_Jv'];
            
            if(isSandbox && md != null){
                if(md.TestEndpoint__c != null)
                    endpoint_x = md.TestEndpoint__c;
            }else{
                if(md.LiveEndpoint__c != null)
                    endpoint_x = md.LiveEndpoint__c;
            }
            ETT_CreateJournalVoucher.execute_element request_x = new ETT_CreateJournalVoucher.execute_element();
            request_x.Journal_Voucher = Journal_Voucher;
            ETT_CreateJournalVoucher.Response_element response_x;
            Map<String, ETT_CreateJournalVoucher.Response_element> response_map_x = new Map<String, ETT_CreateJournalVoucher.Response_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'execute',
              'http://www.et.ae',
              'execute',
              'http://www.et.ae',
              'Response',
              'ETT_CreateJournalVoucher.Response_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}