@isTest
public class ETT_PO_CreatePOTest {
@isTest
    static void POCreate (){
        ETT_PO_CreatePO.OutputParameters_element Output = New ETT_PO_CreatePO.OutputParameters_element();
        Output.PV_OUT_STATUS = 'Teststatus';
        Output.PV_OUT_ERRORMESSAGE = 'TestMsg';
        Output.PV_OUT_PO_NUM = 'test Num';
        Output.PV_OUT_RECEIPT_NUM = 'test Rec Num';
        
        ETT_PO_CreatePO.InputParameters_element Input = New ETT_PO_CreatePO.InputParameters_element();
        Input.P_DOCUMENT_NUM = 'test Doc Num';
    }
}