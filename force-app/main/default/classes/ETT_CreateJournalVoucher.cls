//Generated by wsdl2apex

public class ETT_CreateJournalVoucher {
    public class AuthInfo {
        public String SourceSystem;
        public String Username;
        public String Password;
        private String[] SourceSystem_type_info = new String[]{'SourceSystem','http://www.et.ae',null,'0','1','true'};
        private String[] Username_type_info = new String[]{'Username','http://www.et.ae',null,'0','1','true'};
        private String[] Password_type_info = new String[]{'Password','http://www.et.ae',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'SourceSystem','Username','Password'};
    }
    public class Response_element {
        public String PV_OUT_STATUS;
        public String PV_OUT_ERROR;
        public String PV_OUT_EBIZ_TRX_NO;
        private String[] PV_OUT_STATUS_type_info = new String[]{'PV_OUT_STATUS','http://www.et.ae',null,'0','1','true'};
        private String[] PV_OUT_ERROR_type_info = new String[]{'PV_OUT_ERROR','http://www.et.ae',null,'0','1','true'};
        private String[] PV_OUT_EBIZ_TRX_NO_type_info = new String[]{'PV_OUT_EBIZ_TRX_NO','http://www.et.ae',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'PV_OUT_STATUS','PV_OUT_ERROR','PV_OUT_EBIZ_TRX_NO'};
    }
    public class execute_element {
        public ETT_CreateJournalVoucher.Journal_Header Journal_Voucher;
        private String[] Journal_Voucher_type_info = new String[]{'Journal_Voucher','http://www.et.ae',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'Journal_Voucher'};
    }
    public class Journal_Header {
        public ETT_CreateJournalVoucher.AuthInfo AuthInfo;
        public String Source;
        public String Category;
        public String Reference;
        public Date Date_x;
        public String CurrencyCode;
        public ETT_CreateJournalVoucher.Journal_Lines[] Journal_Lines;
        private String[] AuthInfo_type_info = new String[]{'AuthInfo','http://www.et.ae',null,'1','1','false'};
        private String[] Source_type_info = new String[]{'Source','http://www.et.ae',null,'1','1','false'};
        private String[] Category_type_info = new String[]{'Category','http://www.et.ae',null,'1','1','false'};
        private String[] Reference_type_info = new String[]{'Reference','http://www.et.ae',null,'1','1','false'};
        private String[] Date_x_type_info = new String[]{'Date','http://www.et.ae',null,'1','1','false'};
        private String[] CurrencyCode_type_info = new String[]{'CurrencyCode','http://www.et.ae',null,'1','1','false'};
        private String[] Journal_Lines_type_info = new String[]{'Journal_Lines','http://www.et.ae',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'AuthInfo','Source','Category','Reference','Date_x','CurrencyCode','Journal_Lines'};
    }
    public class Journal_Lines {
        public String Segment1;
        public String Segment2;
        public String Segment3;
        public String Segment4;
        public String Segment5;
        public String Segment6;
        public String Segment7;
        public String Segment8;
        public String Segment9;
        public Decimal DebitAmount;
        public Decimal CreditAmount;
        public String Description;
        private String[] Segment1_type_info = new String[]{'Segment1','http://www.et.ae',null,'1','1','false'};
        private String[] Segment2_type_info = new String[]{'Segment2','http://www.et.ae',null,'1','1','false'};
        private String[] Segment3_type_info = new String[]{'Segment3','http://www.et.ae',null,'1','1','false'};
        private String[] Segment4_type_info = new String[]{'Segment4','http://www.et.ae',null,'1','1','false'};
        private String[] Segment5_type_info = new String[]{'Segment5','http://www.et.ae',null,'1','1','false'};
        private String[] Segment6_type_info = new String[]{'Segment6','http://www.et.ae',null,'1','1','false'};
        private String[] Segment7_type_info = new String[]{'Segment7','http://www.et.ae',null,'1','1','false'};
        private String[] Segment8_type_info = new String[]{'Segment8','http://www.et.ae',null,'1','1','false'};
        private String[] Segment9_type_info = new String[]{'Segment9','http://www.et.ae',null,'1','1','false'};
        private String[] DebitAmount_type_info = new String[]{'DebitAmount','http://www.et.ae',null,'1','1','false'};
        private String[] CreditAmount_type_info = new String[]{'CreditAmount','http://www.et.ae',null,'1','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://www.et.ae',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'Segment1','Segment2','Segment3','Segment4','Segment5','Segment6','Segment7','Segment8','Segment9','DebitAmount','CreditAmount','Description'};
    }
}